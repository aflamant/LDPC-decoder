close all;
clear variables;

%% Initialisation
nbCNodes=4;
nbVNodes=8;

H= [0 1 0 1 1 0 0 1 ; 1 1 1 0 0 1 0 0 ; 0 0 1 0 0 1 1 1 ; 1 0 0 1 1 0 1 0 ];

valide = [1 0 0 1 0 1 0 1];         %message valide transmis
erreur = [0 0 0 1 0 0 1 0];         %bits d'erreur

message = mod(valide + erreur,2);

for i=1:nbVNodes
    if erreur(i)
        proba = abs(message(i)-0.4);    %on a peu confiance dans les bits d'erreur
    else
        proba = abs(message(i)-0.1);    %on a une grande confiance dans les bits corrects
    end
    v_nodes(i)= v_node(proba,nbCNodes);
end

for i=1:nbCNodes
    c_nodes(i)=c_node(nbVNodes);
end


pariteEchouee=1;

nbBoucles = 0; 

%% Main loop
while pariteEchouee > 0 && nbBoucles < 100      %Tant que la parité n'est pas bonne, avec une condition d'arrêt pour éviter une boucle infinie
    

    nbBoucles = nbBoucles + 1;  
   
   %% Envoi des probabilités aux c_nodes
   
   for c = 1:nbCNodes
        for v= 1:nbVNodes
            if H(c,v)
                c_nodes(c) = c_nodes(c).vote(v_nodes(v).Reponses(c),v);
            end
        end
        c_nodes(c) = c_nodes(c).update();
   end
   

   %% Réponse des c_nodes
    for v = 1:nbVNodes
        for c = 1:nbCNodes
            if H(c,v)
                v_nodes(v) = v_nodes(v).vote(c_nodes(c).Reponses(v),c);
            end
        end
        v_nodes(v) = v_nodes(v).update();
    end
    
    
    %% Test de la parité
    
    decodage = [];
    for i=1:nbVNodes
      decodage = [decodage v_nodes(i).Bit];
    end
    
    pariteEchouee = sum(mod(decodage * H' , 2));
    
end


%% Affichage final

decodage = [];

for i=1:nbVNodes
    decodage = [decodage v_nodes(i).Bit];
end

disp(['Nb boucles = ' num2str(nbBoucles)])
disp(['Message envoyé : ' num2str(message)])
disp(['Message décodé : ' num2str(decodage)])

if ~pariteEchouee
    disp('Message valide reconstruit !')
    if decodage == valide
        disp('Bon message reçu !')
    else
        disp('Message erroné reçu')
    end
else
    disp('Reconstruction échouée')
end
