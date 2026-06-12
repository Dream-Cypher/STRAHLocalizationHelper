using Newtonsoft.Json;

namespace Helper
{
    internal class Config
    {
        public string? Platform { get; set; }
        public string? Game { get; set; }
        public string? Language { get; set; }

        /// <summary>
        /// Loads config.json from the executable's directory, falling back to the
        /// current working directory. Returns an empty config (all defaults) if
        /// no config file is found or it can't be parsed.
        /// </summary>
        public static Config Load()
        {
            foreach (var dir in new[] { AppContext.BaseDirectory, Directory.GetCurrentDirectory() })
            {
                var path = Path.Combine(dir, "config.json");
                if (File.Exists(path))
                {
                    try
                    {
                        return JsonConvert.DeserializeObject<Config>(File.ReadAllText(path)) ?? new Config();
                    }
                    catch (JsonException ex)
                    {
                        Console.Error.WriteLine($"Warning: failed to parse {path}: {ex.Message}");
                        break;
                    }
                }
            }
            return new Config();
        }
    }
}
