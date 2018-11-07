classdef v_node
    
    properties
        Bit             %bit deviné par la node
        Q0              %probabilité que le bit soit égal à 0 
        Q1              %probabilité que le bit soit égal à 1
        
        Votes           %bits reçus depuis les c_nodes
        Index           %index du tableau ci-dessus
    end
    
    methods
        function obj=v_node(bit,nbVNodes)
            obj.Bit = bit;
            obj.Q0 = 1-bit
            obj.Q1 = bit;
            obj.Votes = zeros(1,nbVNodes);
            obj.Index = 1;
        end
        
        function r = flip(obj)
            obj.Bit = mod(obj.Bit + 1,2);
            
            r = obj;
        end
        
        function r = vote(obj,vote)
            obj.Votes(obj.Index) = vote;
            obj.Index = obj.Index + 1;
            r = obj;
        end
        
        function r = update(obj)
            if mean(obj.Votes) < 0.5
                obj.Bit = 0;
            elseif mean(obj.Votes) == 0.5
                obj.Bit = obj.Bit;
            else
                obj.Bit = 1;
            end
            obj.Index = 1;
            r = obj;
        end
    end
    
end