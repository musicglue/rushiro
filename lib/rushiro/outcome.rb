module Rushiro
  class Outcome
    def initialize request, levels, permitted_by_default
      @request = request
      @levels = levels
      @current_level = nil
      @permitted = permitted_by_default
    end

    attr_reader :request

    def deny level
      update_from_level level, false if higher_level? level
    end

    def permit level
      update_from_level level, true if higher_level? level
    end

    def permitted?
      @permitted
    end

    private

    def higher_level? level
      return true unless @current_level

      @levels.index(@current_level) <= @levels.index(level)
    end

    def update_from_level level, permitted
      @current_level = level
      @permitted = permitted
    end
  end
end
