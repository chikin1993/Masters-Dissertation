% First function to generate a 2 layer network using the grow-reinforce model
% N is the total number of nodes wanted in the network, seed is the
% starting number of nodes, m is the number of links each new node has, p
% and q are the parameters between 0 and 1
function [alpha, beta] = GRmod_old(N, seed, m, p, q)
    
    % Create 4 vectors to serve as edge lists for the 2 layers
    ialpha = [];
    jalpha = [];
    ibeta = [];
    jbeta = [];
    
    % Firtly we need to create the starting seed network to grow from,
    % currently this just a small cycle
    for i=1:seed-1
        ialpha = [ialpha, i];
        jalpha = [jalpha, i+1];
    end
    ialpha = [ialpha, seed];
    jalpha = [jalpha, 1];
    
    % Work out the number of edges we will be adding to each layer using
    % the values of m, p, q
    % Since the values obtained could be non-integer, the values will be
    % rounded, this may change in a later version
    % one alternative could be to round all values down and allocate left
    % of edges at random
    growingalpha = floor(p*m);
    reinforcebeta = floor(q*(1-p)*m);
    growingbeta = floor((1-q)*(1-p)*m);
    
    % Now need to loop over adding nodes until we have N nodes in total
    for i=seed+1:N
        
        % Now we begin the process of adding the different types of edges
        % to the layers, starting with growing the alpha layer
        edgesadded = 0;
        while edgesadded < growingalpha
        
            % This needs to pick nodes, prefering nodes with a higher
            % degree but retry in the case where a multi-edge would be
            % formed, so node index would correspond to a uniformly chosen
            % end-point
            nodeindex = randi(2*numel(ialpha));
            
            % See which list this value is in, and alter it if needed so we
            % can more easily find its corresponding node, noting which
            % list it was from
            list = "first";
            if nodeindex > numel(ialpha)
               
                nodeindex = nodeindex - numel(ialpha);
                list = "second";
                
            end
            
            % Now call the function to check if this index would lead to a
            % multiple edge
            if dupenodecheck(nodeindex, ialpha, jalpha, i, list) == 0
                
                % Add the new edge, checking which list it came from
                if list == "first"
                    
                    ialpha = [ialpha, i];
                    jalpha = [jalpha, ialpha(nodeindex)];
                    edgesadded = edgesadded + 1;
                    
                else
                    
                    ialpha = [ialpha, i];
                    jalpha = [jalpha, jalpha(nodeindex)];
                    edgesadded = edgesadded + 1;
                
                end
                
            end
            
        end
        
        % Now we choose edges at random from the alpha layer and replicate
        % them in the beta layer, although we do not what multiple edges
        edgesreinforced = 0;
        while edgesreinforced < reinforcebeta
            
            % Draw a value for a random edge
            edgeindex = randi(numel(ialpha));
            
            % Test if this value would cause a multiple edge, if not, add
            % the edge and increase the counter
            if dupeedgecheck(edgeindex, ialpha, jalpha, ibeta, jbeta) == 0
               
                ibeta = [ibeta, ialpha(edgeindex)];
                jbeta = [jbeta, jalpha(edgeindex)];
                edgesreinforced = edgesreinforced + 1;
                
            end
            
        end
        
        % Now we begin the process of adding the different types of edges
        % to the layers, starting with growing the alpha layer
        edgesadded2 = 0;
        while edgesadded2 < growingbeta
        
            % This needs to pick nodes, prefering nodes with a higher
            % degree but retry in the case where a multi-edge would be
            % formed, so node index would correspond to a uniformly chosen
            % end-point
            nodeindex2 = randi(2*numel(ibeta));
            
            % See which list this value is in, and alter it if needed so we
            % can more easily find its corresponding node, noting which
            % list it was from
            list2 = "first";
            if nodeindex2 > numel(ibeta)
               
                nodeindex2 = nodeindex2 - numel(ibeta);
                list2 = "second";
                
            end
            
            % Now call the function to check if this index would lead to a
            % multiple edge
            if dupenodecheck(nodeindex2, ibeta, jbeta, i, list2) == 0
                
                % Check which list the node is in and add it
                if list2 == "first"
                    
                    ibeta = [ibeta, i];
                    jbeta = [jbeta, ibeta(nodeindex2)];
                    edgesadded2 = edgesadded2 + 1;
                
                else
                    
                    ibeta = [ibeta, i];
                    jbeta = [jbeta, jbeta(nodeindex2)];
                    edgesadded2 = edgesadded2 + 1;
                    
                end
                
            end
            
        end
        
    end
    
    % Form the sparce matrices we need from the edge lists we have and return
    % them
    alpha = sparse(ialpha, jalpha, 1, N, N);
    beta = sparse(ibeta, jbeta, 1, N, N);
    
    % Form the symetric matrices
    alpha = alpha + alpha';
    beta = beta + beta';

end