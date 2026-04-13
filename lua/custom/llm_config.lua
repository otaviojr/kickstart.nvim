local M = {}

M.linux_ai1 = {
  __inherited_from = 'openai',
  name = 'linux-ai1 (local)',
  endpoint = 'http://192.168.250.28:8080/v1',
  model = 'qwen3.5-35B',
  timeout = 30000,
  npm = '@ai-sdk/openai-compatible',
  options = {
    baseURL = 'http://192.168.250.28:8080/v1',
    toolParser = {
      { type = 'raw-function-call' },
      { type = 'json' },
    },
  },
  extra_request_body = {
    temperature = 0.75,
    num_ctx = 256000,
    max_tokens = 32768,
  },
  -- Available models for reference
  model_names = {
    'qwen3.5-35B',
    'qwen3.5-122B',
    'gemma4-31B-Q8_0',
    'gemma4-26B',
    'minimax-m2.7',
  },
}

M.openai = {
  name = 'OpenAI',
  endpoint = 'https://api.openai.com/v1',
  model = 'gpt-5.4',
  api_key_name = 'OPENAI_API_KEY',
  extra_request_body = {
    temperature = 0.2,
  },
  models = {
    ['gpt-5.4'] = {
      name = 'GPT-5.2',
      tool_call = true,
      reasoning = true,
      stream = true,
      attachment = true,
      modalities = { input = { 'text', 'image' }, output = { 'text' } },
      limit = { context = 1050000, output = 128000 },
    },
    ['gpt-5.4-mini'] = {
      name = 'GPT-5.4 Mini',
      tool_call = true,
      reasoning = true,
      stream = true,
      attachment = true,
      modalities = { input = { 'text', 'image' }, output = { 'text' } },
      limit = { context = 400000, output = 128000 },
    },
    ['gpt-5.4-nano'] = {
      name = 'GPT-5.4 Nano',
      tool_call = true,
      reasoning = true,
      stream = true,
      attachment = true,
      modalities = { input = { 'text', 'image' }, output = { 'text' } },
      limit = { context = 400000, output = 128000 },
    },
  },
}

M.avante_opts = {
  mode = 'agentic',
  provider = 'linux-ai1',
  auto_suggestions_provider = 'linux-ai1',
  file_selector = {
    telescope = {},
  },
  input = {
    provider = 'dressing',
    provider_opts = {},
  },
  planning = {
    enabled = true,
    auto_approve = {
      'read_file',
      'read_file_toplevel_symbols',
      'glob',
      'search_keyword',
      'rag_search',
      'git_diff',
    },
  },
  behaviour = {
    auto_suggestions = true,
    minimize_diff = true,
    enable_cursor_planning_mode = false,
    auto_apply_diff_after_generation = false,
    auto_approve_tool_permissions = {
      'read_file',
      'read_file_toplevel_symbols',
      'glob',
      'search_keyword',
      'rag_search',
      'git_diff',
    },
  },
  web_search_engine = {
    enable = true,
    provider = 'tavily',
    proxy = nil,
  },
  rules = {
    project_dir = '.avante/rules',
    global_dir = vim.fn.expand '~/.config/nvim/avante/rules',
  },
  providers = {
    openai = M.openai,
    ['linux-ai1'] = M.linux_ai1,
  },
}

function M.switch_avante_config(provider_name, model_name, num_ctx, max_tokens, xml_format)
  M.avante_opts.provider = provider_name
  M.avante_opts.auto_suggestions_provider = provider_name
  M.avante_opts.providers[provider_name].model = model_name

  if xml_format ~= nil then
    M.avante_opts.providers[provider_name].use_xml_format = xml_format
  else
    M.avante_opts.providers[provider_name].use_xml_format = nil
  end

  -- Initialize extra_request_body if it doesn't exist yet
  if not M.avante_opts.providers[provider_name].extra_request_body then
    M.avante_opts.providers[provider_name].extra_request_body = {}
  end

  if max_tokens and max_tokens > 0 then
    M.avante_opts.providers[provider_name].extra_request_body.max_tokens = max_tokens
  else
    M.avante_opts.providers[provider_name].extra_request_body.max_tokens = nil
  end

  if num_ctx and num_ctx > 0 then
    M.avante_opts.providers[provider_name].extra_request_body.num_ctx = num_ctx
  else
    M.avante_opts.providers[provider_name].extra_request_body.num_ctx = nil
  end

  require('avante').setup(M.avante_opts)
end

return M
