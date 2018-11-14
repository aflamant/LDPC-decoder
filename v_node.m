classdef v_node
    
    properties
        Bit             %bit deviné par la node
        P               %probabilité que le bit soit égal à 1 sachant y
        
        Votes           %probabilités que le bit soit 1 reçues depuis les c_nodes
        Reponses        
    end
    
    methods
        function obj=v_node(bit,nbCNodes)
            obj.Bit = bit;
            obj.P = abs(bit - 0.2);        % 0.9 si 1, 0.1 si 0 (on part du principe que Pi = 0.9)
            
            obj.Votes = nan(1,nbCNodes);
            obj.Reponses = obj.P * ones(1,nbCNodes);
        end
        
        function r = vote(obj,value,index)
            obj.Votes(index) = value;
            r = obj;
        end
        
        function r = update(obj)
            for i=1:length(obj.Reponses)
                prod = obj.P;           %calcul correspondant à q1
                prod2 = (1 - obj.P);    %calcul correspondant à q0
                for j=setdiff(1:length(obj.Votes),i)      %toutes les cases sauf i
                    if ~isnan(obj.Votes(j))
                        prod = prod * obj.Votes(j);
                        prod2 = prod2 * (1 - obj.Votes(j));
                    end
                end
                K = 1 / ( prod + prod2);
                obj.Reponses(i) = K * prod;
            end
            Q1 = obj.P;
            Q0 = 1 - Q1;
            for i=1:length(obj.Votes)
                if ~isnan(obj.Votes(i))
                    Q1 = Q1 * obj.Votes(i);
                    Q0 = Q0 * ( 1 - obj.Votes(i));
                end
            end
            
%             obj.P = Q1;
            
            if Q1>Q0
                obj.Bit = 1;
            else
                obj.Bit = 0;
            end
            
            r = obj;
        end
    end
    
end