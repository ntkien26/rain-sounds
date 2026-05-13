const jsonHeaders = {
  "content-type": "application/json; charset=utf-8",
  "cache-control": "no-store",
};

type KeepAliveResponse = {
  ok: boolean;
  status: "ok" | "unauthorized" | "misconfigured" | "upstream_error" | "method_not_allowed";
  checkedAt: string;
  upstreamStatus?: number;
  rowCount?: number;
  error?: string;
};

function jsonResponse(body: KeepAliveResponse, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: jsonHeaders,
  });
}

function validateOptionalBearerSecret(request: Request): boolean {
  const keepAliveSecret = Deno.env.get("KEEP_ALIVE_SECRET");

  // Secret protection is optional. Configure KEEP_ALIVE_SECRET to require
  // a matching Authorization bearer token from scheduled callers.
  if (!keepAliveSecret) {
    return true;
  }

  const expectedHeader = `Bearer ${keepAliveSecret}`;
  return request.headers.get("authorization") === expectedHeader;
}

Deno.serve(async (request) => {
  const checkedAt = new Date().toISOString();

  if (request.method !== "GET" && request.method !== "POST") {
    return jsonResponse(
      {
        ok: false,
        status: "method_not_allowed",
        checkedAt,
        error: "Only GET and POST are supported.",
      },
      405,
    );
  }

  if (!validateOptionalBearerSecret(request)) {
    return jsonResponse(
      {
        ok: false,
        status: "unauthorized",
        checkedAt,
        error: "Missing or invalid Authorization bearer token.",
      },
      401,
    );
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  if (!supabaseUrl || !serviceRoleKey) {
    return jsonResponse(
      {
        ok: false,
        status: "misconfigured",
        checkedAt,
        error: "SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be configured.",
      },
      500,
    );
  }

  const restUrl = new URL("/rest/v1/group_music", supabaseUrl);
  restUrl.searchParams.set("select", "id");
  restUrl.searchParams.set("limit", "1");

  try {
    const upstreamResponse = await fetch(restUrl, {
      method: "GET",
      headers: {
        apikey: serviceRoleKey,
        authorization: `Bearer ${serviceRoleKey}`,
        accept: "application/json",
      },
    });

    const responseText = await upstreamResponse.text();
    let rows: unknown = [];

    if (responseText.length > 0) {
      try {
        rows = JSON.parse(responseText);
      } catch {
        rows = [];
      }
    }

    if (!upstreamResponse.ok) {
      return jsonResponse(
        {
          ok: false,
          status: "upstream_error",
          checkedAt,
          upstreamStatus: upstreamResponse.status,
          error: responseText || upstreamResponse.statusText,
        },
        502,
      );
    }

    return jsonResponse({
      ok: true,
      status: "ok",
      checkedAt,
      upstreamStatus: upstreamResponse.status,
      rowCount: Array.isArray(rows) ? rows.length : 0,
    });
  } catch (error) {
    return jsonResponse(
      {
        ok: false,
        status: "upstream_error",
        checkedAt,
        error: error instanceof Error ? error.message : "Unknown upstream error.",
      },
      502,
    );
  }
});
