module GitHubClient
  class Logger
    def initialize(io=STDERR)
      @io = io
      @level = :error
    end
    
    def level=(setting)
      @level = setting
    end
    
    LEVELS = [:trace, :debug, :info, :warn, :error]
    LEVELS.each do |level|
      define_method(level) { |*msg| say(msg, level) }
    end

    def say(msg, level)
      if LEVELS.index(level) >= LEVELS.index(@level)
        print_start level
        print_parts level, Array(msg)
      end
    end
    
    def print_start(level)
      @io.print(prefix = '[%s] - ' % [level.to_s.upcase])
    end
    
    def print_parts(level, parts)
      prefix = '[%s] - ' % [level.to_s.upcase]
      parts.each do |str|
        @io.print prefix.gsub(/./, ' ') unless parts.first == str
        @io.puts str
      end
    end
  end
end
