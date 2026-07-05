import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { AccessToken } from "npm:livekit-server-sdk";

declare const Deno: any;

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req: Request) => {
  // Handle CORS preflight requests
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { groupId } = await req.json();
    if (!groupId) {
      return new Response(
        JSON.stringify({ error: "Missing groupId parameter" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Access LiveKit credentials from Supabase Environment Secrets
    const apiKey = Deno.env.get("LIVEKIT_API_KEY");
    const apiSecret = Deno.env.get("LIVEKIT_API_SECRET");

    if (!apiKey || !apiSecret) {
      return new Response(
        JSON.stringify({ error: "LiveKit credentials (LIVEKIT_API_KEY / LIVEKIT_API_SECRET) are not configured in Supabase Secrets." }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Generate a unique participant identity for this session connection
    const participantId = `rider-${crypto.randomUUID().substring(0, 8)}`;

    // Create the LiveKit Access Token
    const at = new AccessToken(apiKey, apiSecret, {
      identity: participantId,
      ttl: "2h", // Token valid for 2 hours
    });

    // Grant room permissions (join room and publish/subscribe to audio tracks)
    at.addGrant({
      roomJoin: true,
      room: `group-${groupId}`,
      canPublish: true,
      canSubscribe: true,
      canPublishData: true,
    });

    const token = await at.toJwt();

    return new Response(
      JSON.stringify({ token }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (error: any) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
