classdef c_node
    
    properties
        Parity 
    end
    
    methods
        function obj = c_node()
            obj.Parity = 0;
        end
        
        function r = flip(obj)
            obj.Parity = mod(obj.Parity + 1,2);
            r = obj;
        end
        
        function r = raz(obj)
            obj.Parity = 0;
            r=obj;
        end
    end
end