classdef c_node
    
    properties
        Parity          %the parity of this check node
        
        Votes           %the information received from the corresponding v_nodes
        Reponses        %les réponses à donner aux v_nodes
    end
    
    methods
        function obj = c_node(nbVNodes)
            obj.Parity = 0;
            
            obj.Votes = nan(1,nbVNodes);
            obj.Reponses = zeros(1,nbVNodes);
        end
        
        function r = vote(obj,value,index)
            obj.Votes(index) = value;
            r = obj;
        end
        
        function r = update(obj)
            for i=1:length(obj.Reponses)
                prod = 0.5;
                for j=setdiff(1:length(obj.Votes),i)      %toutes les cases sauf i
                    if ~isnan(obj.Votes(j))
                        prod = prod * (1 - 2 * obj.Votes(j));
                    end
                end
                obj.Reponses(i) = 1 - ( 0.5 + prod );
            end
            r = obj;
        end
    end
end