close all;
clear variables;

%% Initialisation
nbCNodes=4;
nbVNodes=8;

H= [0 1 0 1 1 0 0 1 ; 1 1 1 0 0 1 0 0 ; 0 0 1 0 0 1 1 1 ; 1 0 0 1 1 0 1 0 ]; 

message= [1 1 0 1 0 1 0 1 ];

for i=1:nbVNodes
    v_nodes(i)= v_node(message(i),nbCNodes);
end

for i=1:nbCNodes
    c_nodes(i)=c_node(nbVNodes);
end


pariteRespectee=1;

nbBoucles = 0; 

%% Main loop
while pariteRespectee > 0 && nbBoucles < 100      % Si il y a eu une correction dans la dernière boucle, on continue
    

    nbBoucles = nbBoucles + 1;  
   
   %% Envoi des probas aux c_nodes
   
   for c = 1:nbCNodes
        for v= 1:nbVNodes
            if H(c,v)
                c_nodes(c) = c_nodes(c).vote(v_nodes(v).Reponses(c),v);
            end
        end
        c_nodes(c) = c_nodes(c).update();
   end
   

   %% Réponse des c_nodes
%    for c = 1:nbCNodes
%         if c_nodes(c).Parity                        % test de parité échoué
%             pariteRespectee = pariteRespectee + 1;  % on execute la boucle une fois de plus la prochaine fois
%             for v = 1:nbVNodes
%                 if H(c,v)
%                     v_nodes(v) = v_nodes(v).vote(~v_nodes(v).Bit);
%                 end
%             end
%         else
%             for v = 1:nbVNodes
%                 if H(c,v)
%                     v_nodes(v) = v_nodes(v).vote(v_nodes(v).Bit);
%                 end
%             end
%         end
%    end
   
    for v = 1:nbVNodes
        for c = 1:nbCNodes
            if H(c,v)
                v_nodes(v) = v_nodes(v).vote(c_nodes(c).Reponses(v),c);
            end
        end
        v_nodes(v) = v_nodes(v).update();
    end
    
    decodage = [];

    for i=1:nbVNodes
      decodage = [decodage v_nodes(i).Bit];
    end
    
    pariteRespectee = sum(mod(decodage * H' , 2));
    
end


%% Affichage final

decodage = [];

for i=1:nbVNodes
    decodage = [decodage v_nodes(i).Bit];
end

disp(['Nb boucles = ' num2str(nbBoucles)])
disp(['Message envoyé : ' num2str(message)])
disp(['Message décodé : ' num2str(decodage)])
