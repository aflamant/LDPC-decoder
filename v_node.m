classdef v_node
    
    properties
        Bit             %bit devin� par la node
        Q0              %probabilit� que le bit soit �gal � 0 
        Q1              %probabilit� que le bit soit �gal � 1
        
        Votes           %bits re�us depuis les c_nodes
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