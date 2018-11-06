close all;
clear all;

%% Initialisation
nbCNodes=4;
nbVNodes=8;

H= [0 1 0 1 1 0 0 1 ; 1 1 1 0 0 1 0 0 ; 0 0 1 0 0 1 1 1 ; 1 0 0 1 1 0 1 0 ]; 

message= [1 1 0 1 0 1 0 1 ];

%OK=zeros(1,nbVNodes);
pariteRespectee=zeros(1,nbCNodes);

nbBoucles = 0; 

%% Hard-decision decoding 
 
guess=message; % ce que l'algorithme essaie de décoder

while sum(pariteRespectee)<nbCNodes % tant que la parité n'est pas respectée pour chaque c-node
   
    nbBoucles=nbBoucles+1;
    
    %Etape 1 : les v-nodes envoient ce qu'ils croient juste
    
    test=zeros(nbCNodes,nbVNodes); % ce que les v-nodes envoient au c-nodes 

    for c = 1:nbCNodes
        for v= 1:nbVNodes
            if H(c,v)==1 
                test(c,v)=guess(v);
            else 
                test(c,v)=NaN; % on met NaN pour ne pas confondre avec les 0 'binaires'
            end
        end
    end

    %Etape 2 : calcul de la réponse des c-nodes

    somme=zeros(1,nbCNodes); % chaque c-node fait la somme des bits reçus par chaque v-node

    for c=1:nbCNodes
        for v=1:nbVNodes
            if H(c,v)==1 
                somme(1,c)=mod(somme(1,c)+test(c,v),2);
            end
        end
    end

    res=zeros(nbCNodes,nbVNodes);  %chaque c-node envoie à chaque v-node ce qu'il croit être le bon bit
    
    for c = 1:nbCNodes
        for v= 1:nbVNodes
            res(c,v)=NaN;
        end
    end


    for c=1:nbCNodes
        if somme(1,c)==1 % la parité n'est pas respectée, on change la valeur du bit
            pariteRespectee(1,c)=0; % indique que la parité n'est pas respectée
            for v=1:nbVNodes
               if test(c,v)==1
                   res(c,v)=0; 
               elseif test(c,v)==0
                   res(c,v)=1;
               end
            end
        elseif somme(1,c)==0 % la parité est respectée
            pariteRespectee(1,c)=1; % indique que la parité est respectée
            for v=1:nbVNodes
                res(c,v)=test(c,v);
            end
        end
    end

    %Etape 3 : Comparaison

    checksum=zeros(2,nbVNodes); % on compte le nombre de 0 ( ligne 1 ) et 1 ( ligne 2 ) pour chaque v-node

    for v=1:nbVNodes
        for c=1:nbCNodes
            if H(c,v)==1
                if res(c,v)==0
                    checksum(1,v)=checksum(1,v)+1;
                elseif res(c,v)==1
                    checksum(2,v)=checksum(2,v)+1;
                end
            end
        end
        if message(v)==0
            checksum(1,v)= checksum(1,v)+1;
        elseif message(v)==1
            checksum(2,v)=checksum(2,v)+1;
        end
    end

    %Etape 4 : Décision

    decodage=zeros(1,nbVNodes); %message décodé et corrigé

    for v=1:nbVNodes
        [Y,I] = max(checksum(:,v)); % renvoie le max d'un vecteur et son indice I  
        if I==1 % si le max est relevé pour l'indice 1,
            decodage(1,v)=0; % alors on met la valeur 0.
        elseif I==2  % si le max est relevé pour l'indice 2,
            decodage(1,v)=1; % alors on met la valeur 1.
        end
        if guess(v)~=decodage(v)
            guess(v)=mod(guess(v)+1,2);
        end
    end
    
end
    
    
% Affichage des résultats 

disp(['Nb boucles = ' num2str(nbBoucles)])
disp(['Message envoyé : ' num2str(message)])
disp(['Message décodé : ' num2str(decodage)])


 




