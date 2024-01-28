classdef queueFIFO < handle

    properties
        queue = {}
    end

    methods

        function obj = queueFIFO()
            obj.queue = {};
        end

        function elem = pop(obj)
            elem = obj.queue{1};
            obj.queue(1) = [];
        end

        function obj = push(obj, elem)
            obj.queue(end + 1) = {elem};
        end

        function b = isempty(obj)
            b = isempty(obj.queue);
        end

    end

end