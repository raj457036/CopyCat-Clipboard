export function parseJwt(token: string): any {
  if (!token) {
    return {};
  }

  const payload = token.split(".")[1];

  const normalized = payload.replace(/-/g, "+").replace(/_/g, "/");

  return JSON.parse(atob(normalized));
}
