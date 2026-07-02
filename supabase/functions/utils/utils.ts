export function parseJwt(token: string): any {
  const payload = token.split(".")[1];

  const normalized = payload.replace(/-/g, "+").replace(/_/g, "/");

  return JSON.parse(atob(normalized));
}
