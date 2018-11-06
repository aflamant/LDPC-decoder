close all;
clear variables;

%% Initialisation
nbCNodes=4;
nbVNodes=8;

H= [0 1 0 1 1 0 0 1 ; 1 1 1 0 0 1 0 0 ; 0 0 1 0 0 1 1 1 ; 1 0 0 1 1 0 1 0 ]; 

message= [1 1 0 1 0 1 0 1 ];

for i=1:nbVNodes
    v_nodes(i)= v_node(message(i),sum(H(i)));
end

for i=1:nbCNodes
    c_nodes(i)=c_node();
end


pariteRespectee=1;

nbBoucles = 0; 

%% Main loop
while pariteRespectee > 0       % Si il y a eu une correction dans la dernière boucle, on continue
    
    pariteRespectee = 0;        %Remise à zéro de la variable
    nbBoucles = nbBoucles + 1;  
   
   %% Envoi des bits aux c_nodes
   
   for c = 1:nbCNodes
        for v= 1:nbVNodes
            if H(c,v)
                if v_nodes(v).Bit
                    c_nodes(c) = c_nodes(c).flip();
                end
            end
        end
   end
   

   %% Réponse des c_nodes
   for c = 1:nbCNodes
        if c_nodes(c).Parity                        % test de parité échoué
            pariteRespectee = pariteRespectee + 1;  % on execute la boucle une fois de plus la prochaine fois
            for v = 1:nbVNodes
                if H(c,v)
                    v_nodes(v) = v_nodes(v).vote(mod(v_nodes(v).Bit + 1, 2));
                end
            end
        else
            for v = 1:nbVNodes
                if H(c,v)
                    v_nodes(v) = v_nodes(v).vote(v_nodes(v).Bit);
                end
            end
        end
   end
   
   %% Mise à jour des v_nodes et remise à zéro des c_nodes
   for v = 1:nbVNodes
      v_nodes(v) = v_nodes(v).update(); 
   end
   
   for c = 1:nbCNodes
       c_nodes(c) = c_nodes(c).raz();
   end
end


%% Affichage final

decodage = [];

for i=1:nbVNodes
    decodage = [decodage v_nodes(i).Bit];
end

disp(['Nb boucles = ' num2str(nbBoucles)])
disp(['Message envoyé : ' num2str(message)])
disp(['Message décodé : ' num2str(decodage)])
