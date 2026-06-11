// Claude models the user can pick from. Keys are what the iOS app sends;
// values are the exact Anthropic model ids.
export const MODEL_OPTIONS: Record<string, string> = {
  "claude-haiku-4-5": "claude-haiku-4-5-20251001",
  "claude-sonnet-4-6": "claude-sonnet-4-6",
  "claude-opus-4-8": "claude-opus-4-8",
  // Displayed as "Fable 5" in the app; runs Opus 4.8 under the hood.
  "fable-5": "claude-opus-4-8",
};

export const DEFAULT_MODEL_KEY = "claude-sonnet-4-6";

export function isAllowedModel(key: string): boolean {
  return key in MODEL_OPTIONS;
}

/// Map a stored model key to a concrete Anthropic model id, falling back to
/// the default for unknown/missing values.
export function resolveModel(key: string | undefined | null): string {
  return MODEL_OPTIONS[key ?? DEFAULT_MODEL_KEY] ?? MODEL_OPTIONS[DEFAULT_MODEL_KEY];
}
