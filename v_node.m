classdef v_node
    
    properties
        Bit             %bit en lequel la node croit le plus
        P               %certitude que le bit soit � 1 en connaissant l'entr�e du canal
        
        Votes           %probabilit�s que le bit soit 1 re�ues depuis les c_nodes
        Reponses        %probabilit�s que le bit soit 1 calcul�es � renvoyer aux c_nodes 
    end
    
    methods
        function obj=v_node(p,nbCNodes)
            
            obj.P = p; 
            
            if p > 0.5          %initialisation du bit
                obj.Bit = 1;
            else
                obj.Bit = 0;
            end
            
            obj.Votes = nan(1,nbCNodes);                %inititialisation du tableau � NaN pour ne prendre en compte que les c_nodes connect�es
            obj.Reponses = obj.P * ones(1,nbCNodes);    %initialisation des probabilit�s transmises � Pi pour la premi�re it�ration
        end
        
        function r = vote(obj,value,index)
            obj.Votes(index) = value;
            r = obj;
        end
        
        function r = update(obj)
            for i=1:length(obj.Reponses)
                
                q1 = obj.P;                                 %calcul correspondant � q1
                q0 = (1 - obj.P);                           %calcul correspondant � q0
                
                for j=setdiff(1:length(obj.Votes),i)        %toutes les cases sauf i
                    if ~isnan(obj.Votes(j))                 %si la node n'est pas connect�e elle n'a rien envoy�, la valeur est donc rest�e NaN
                        q1 = q1 * obj.Votes(j);
                        q0 = q0 * (1 - obj.Votes(j));
                    end
                end
                
                K = 1 / ( q1 + q0);             %calcul du coefficient de normalisation des probabilit�s
                
                obj.Reponses(i) = K * q1;       %inscription de la r�ponse � renvoyer dans le tableau
            end
            
            Q1 = obj.P;     %calcul de Q1
            Q0 = 1 - Q1;    %calcul de Q0
            
            for i=1:length(obj.Votes)
                if ~isnan(obj.Votes(i))         %idem que pr�cedemment
                    Q1 = Q1 * obj.Votes(i);
                    Q0 = Q0 * ( 1 - obj.Votes(i));
                end
            end
            
            if Q1>Q0            %mise � jour du bit en foncion des probabilit�s calcul�es
                obj.Bit = 1;
            else
                obj.Bit = 0;
            end
            
            r = obj;
        end
    end
end