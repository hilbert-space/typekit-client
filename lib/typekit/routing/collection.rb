module Typekit
  module Routing
    class Collection < Node
      def assemble(request, *path)
        @scope.each { |chunk| request << chunk }
        request << @name unless dummy?
        return authorize(request) if path.empty?
        request << path.shift unless dummy? # id
        return authorize(request) if path.empty?
        find_child(path.shift).assemble(request, *path)
      end
    end
  end
end
