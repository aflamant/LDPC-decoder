classdef c_node
    
    properties
        Votes           %probabilités que le bit soit 1 reçues depuis les c_nodes
        Reponses        %les réponses à envoyer aux v_nodes
    end
    
    methods
        function obj = c_node(nbVNodes)
            obj.Votes = nan(1,nbVNodes);        %initialisation des Votes à NaN pour ne prendre en compte que les v_nodes connectées
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
                
                obj.Reponses(i) = 1 - ( 0.5 + prod );       %à renvoyer: rij(1)
            end
            r = obj;
        end
    end
end