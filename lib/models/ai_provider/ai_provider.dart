import 'package:isar_community/isar.dart';

part 'ai_provider.g.dart';

List<AiProvider> defaultProviders = [
  AiProvider(
    name: "OpenAI",
    devName: "openai",
    apiLink: "https://api.openai.com/v1",
    openAiCompatible: true,
    apiKey: "",
    needsApiKey: true,
    models: [
      "gpt-5",
      "gpt-5-mini",
      "gpt-5-nano",
      "gpt-4.1",
      "gpt-4.1-mini",
      "gpt-4o",
      "o3-deep-research",
      "o3",
      "o4-mini-deep-research",
      "o4-mini",
      // "gpt-oss-120b",
      // "gpt-oss-20b",
    ],
    temperature: 0.3,
    inUse: true,
    iconFileName: "assets/provider_logos/openai.png",
    providerInfo: "Get your API key from platform.openai.com",
  ),
  AiProvider(
    name: "Anthropic",
    devName: "anthropic",
    apiLink: "https://api.anthropic.com",
    openAiCompatible: false,
    apiKey: "",
    needsApiKey: true,
    models: [
      "claude-opus-4-1-20250805",
      "claude-opus-4-20250514",
      "claude-sonnet-4-20250514",
      "claude-3-7-sonnet-latest",
      "claude-3-5-haiku-latest",
      "claude-3-haiku-20240307",
    ],
    temperature: 0.3,
    inUse: false,
    iconFileName: "assets/provider_logos/anthropic.png",
    providerInfo: "Get your API key from console.anthropic.com",
  ),
  AiProvider(
    name: "DeepSeek",
    devName: "deepseek-openai",
    apiLink: "https://api.deepseek.com",
    openAiCompatible: true,
    apiKey: "",
    needsApiKey: true,
    models: [
      "deepseek-chat",
      "deepseek-reasoner",
    ],
    temperature: 0.3,
    inUse: false,
    iconFileName: "assets/provider_logos/deepseek.png",
    providerInfo: "Get your API key from platform.deepseek.com. Cost-effective models with strong performance",
  ),
  AiProvider(
    name: "Ollama",
    devName: "ollama",
    apiLink: "http://localhost:11434/",
    openAiCompatible: false,
    apiKey: "",
    needsApiKey: false,
    models: [
      "gpt-oss:120b",
      "gpt-oss:20b",
      "gemma3:27b",
      "gemma3:12b",
      "gemma3:4b",
      "gemma3:1b",
      "deenseek-v3.1:671b",
      "deepseek-r1:8b",
      "qwen3:30b",
      "qwen3:8b",
      "qwen3:4b",
    ],
    temperature: 0.3,
    inUse: false,
    iconFileName: "assets/provider_logos/ollama.png",
    providerInfo: "Run models locally with Ollama. Make sure Ollama is running on your network",
  ),
  AiProvider(
    name: "Google",
    devName: "google-openai",
    apiLink: "https://generativelanguage.googleapis.com/v1beta/openai/",
    openAiCompatible: true,
    apiKey: "",
    needsApiKey: true,
    models: [
      "gemini-2.5-flash-lite",
      "gemini-2.5-flash",
      "gemini-2.5-pro",
      "gemini-2.0-flash",
      "gemini-2.0-flash-lite",
    ],
    temperature: 0.3,
    inUse: false,
    iconFileName: "assets/provider_logos/gemini.png",
    providerInfo: "Get your API key from aistudio.google.com",
  ),
  AiProvider(
    name: "Groq",
    devName: "groq-openai",
    apiLink: "https://api.groq.com/openai/v1",
    openAiCompatible: true,
    apiKey: "",
    needsApiKey: true,
    models: [
      "llama-3.1-8b-instant",
      "llama-3.3-70b-versatile",
      "openai/gpt-oss-120b",
      "openai/gpt-oss-20b",
      "deepseek-r1-distill-llama-70b",
      "moonshotai/kimi-k2-instruct",
      "meta-llama/llama-4-maverick-17b-128e-instruct",
      "meta-llama/llama-4-scout-17b-16e-instruct",
    ],
    temperature: 0.3,
    inUse: false,
    iconFileName: "assets/provider_logos/groq.png",
    providerInfo: "Get your API key from console.groq.com. Ultra-fast inference with various open source models. Groq is this app's provider of choice",
  ),
  AiProvider(
    name: "OpenRouter",
    devName: "openrouter",
    apiLink: "https://openrouter.ai/api/v1",
    openAiCompatible: true,
    apiKey: "",
    needsApiKey: true,
    models: [
      "anthropic/claude-sonnet-4",
      "google/gemini-2.5-flash",
      "google/gemini-2.0-flash-001",
      "deepseek/deepseek-chat-v3.1",
      "google/gemini-2.5-pro",
      "qwen/qwen3-coder",
      "anthropic/claude-3.7-sonnet",
      "deepseek/deepseek-r1-0528-qwen3-8b:free",
      "deepseek/deepseek-chat-v3.1:free",
      "mistralai/mistral-nemo",
      "openai/gpt-5",
      "openai/gpt-4.1",
      "openai/gpt-4o-mini",
      "openai/gpt-5-mini",
      "openai/gpt-oss-120b:free",
      "openai/gpt-oss-20b:free",
      "moonshotai/kimi-k2:free",
      "z-ai/glm-4.5-air:free",
    ],
    temperature: 0.3,
    inUse: false,
    iconFileName: "assets/provider_logos/openrouter.png",
    providerInfo: "Get your API key from openrouter.ai",
  ),
];

@collection
class AiProvider {
  Id id = Isar.autoIncrement;
  // configs
  String name;
  String devName;
  bool openAiCompatible;
  List<String> models;
  String iconFileName;
  String providerInfo;
  // user settings
  String apiLink;
  String apiKey;
  bool needsApiKey;
  double temperature = 0.3;
  int modelToUseIndex = 0;
  bool useSameModelForSuggestions = true;
  int modelToUseIndexForSuggestions = 0;
  bool inUse;

  AiProvider({
    required this.name,
    required this.devName,
    required this.apiLink,
    required this.openAiCompatible,
    required this.apiKey,
    required this.models,
    required this.temperature,
    required this.needsApiKey,
    required this.inUse,
    required this.iconFileName,
    required this.providerInfo,
  });

  @override
  int get hashCode => id.hashCode ^ devName.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AiProvider && id == other.id && devName == other.devName;
  }

  bool hasConfigChanged(AiProvider other) {
    if (devName == other.devName) {
      return iconFileName != other.iconFileName || providerInfo != other.providerInfo || apiLink != other.apiLink;
    } else {
      return false;
    }
  }

  void adoptNewConfig(AiProvider other) {
    models = other.models;
    iconFileName = other.iconFileName;
    providerInfo = other.providerInfo;
  }
}
