classdef c_node
    
    properties
        Parity          %the parity of this check node
        R0              %the probability of an even number of 1s
        R1              %the probability of an odd number of 1s
        
        Votes           %the information received from the corresponding v_nodes
        Index           %the index of the above array
    end
    
    methods
        function obj = c_node()
            obj.Parity = 0;
        end
        
        function r = flip(obj)
            obj.Parity = mod(obj.Parity + 1,2);
            r = obj;
        end
        
        function r = update(obj)
            obj.Parity = 0;
            r=obj;
        end
    end
end