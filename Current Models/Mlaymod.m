% A function to generate a multilayer network of a given number of layers
% similar to the Grow-Reinforce model
function adjmats = Mlaymod(N, m_0, m, M, r, q)
        
    % Create a cell to hold the vectors we will use
    cellvec = cell(M, 2);
    
    % Loop over the layers and add a starting cycle to each to grow from,
    % initially this was just for the first layer, but was changed when it
    % was found the model would be unable to add more edges as could only
    % choose from replicated edges.
    for k = 1:M
        
        % Add a small cycle to the first layer to grow from
        for i=1:m_0-1

            cellvec{k,1} = [cellvec{k,1}, i];
            cellvec{k,2} = [cellvec{k,2}, i+1];

        end

        % Adding an edge to close the cycle
        cellvec{k,1} = [cellvec{k,1}, m_0];
        cellvec{k,2} = [cellvec{k,2}, 1];
        
    end
    
    % Now we begin adding nodes to the network, starting initially with
    % allocating edges by preferentail attactment
    for i=m_0+1:N
       
        % Add edges to the first layer by preferential attachment
        added1 = 0;
        while added1 < m
            
            % This needs to pick nodes, prefering nodes with a higher
            % degree but retry in the case where a multi-edge would be
            % formed, so node index would correspond to a uniformly chosen
            % end-point
            index = randi(2*numel(cellvec{1,1}));
            
            % See which list this value is in, and alter it if needed so we
            % can more easily find its corresponding node, noting which
            % list it was from
            list = "first";
            if index > numel(cellvec{1,1})
               
                index = index - numel(cellvec{1,1});
                list = "second";
                
            end
            
            % Now call the function to check if this index would lead to a
            % multiple edge
            if duplicatecheck(i, index, list, cellvec{1,1}, cellvec{1,2}) == 0
                
                % Add the new edge, checking which list it came from
                if list == "first"
                    
                    cellvec{1,1} = [cellvec{1,1}, i];
                    cellvec{1,2} = [cellvec{1,2}, cellvec{1,1}(index)];
                    added1 = added1 + 1;
                    
                else
                    
                    cellvec{1,1} = [cellvec{1,1}, i];
                    cellvec{1,2} = [cellvec{1,2}, cellvec{1,2}(index)];
                    added1 = added1 + 1;
                
                end
                
            end
            
        end
        
        % Now we begin the process of sampling, replicating and allocating,
        % as we are repeating this process for an unknown number of layers
        % (at most M) this will done in a while loop to determine if a node
        % has "passed" the sampling for this layer
        nodeactive = "True";
        currentlayer = 2;
        while nodeactive == "True" && currentlayer <= M
           
            % Sample a random variable to compare to r to see if the node
            % will become active on this layer
            rsamp = rand();
            
            % Compare the sampled value to the given r, and if is passes
            % then move on to the reinforcement and allocation of the edges
            if rsamp < r
               
                % Firstly we need to replicate edges in this layer from the
                % previous using our given value of q, this is done by
                % looping over the edges of this node in the previous layer
                % to find the number we need and assigning them using a
                % random permuation of their order
                m_r = 0;
                for l = 1:numel(find(cellvec{currentlayer-1,1} == i))
            
                    % Loop over and use counters to determine the number of edges
                    % required to be reinforced
                    qsamp = rand();
                    if qsamp < q                
                        m_r = m_r + 1;                               
                    end
            
                end
                
                % Now we know we need to replicate m_r edges, we now add
                % them to the current layer in a randomly selected order
                newedges = find(cellvec{currentlayer-1,1} == i);
                newedgesperm = randsample(newedges, m_r);
                for o=1:m_r

                    cellvec{currentlayer,1} = [cellvec{currentlayer,1}, cellvec{currentlayer-1,1}(newedgesperm(o))];
                    cellvec{currentlayer,2} = [cellvec{currentlayer,2}, cellvec{currentlayer-1,2}(newedgesperm(o))];

                end
                
                % Now we need to allocate any leftover edges we have after
                % reinforcement, so firstly calculate this number
                remaining = m - m_r;
                
                % Add edges by preferenial attachment untill we have no
                % more to allocate
                while remaining > 0
                    
                    % Choose a random index location
                    index = randi(2*numel(cellvec{currentlayer,1}));
                    
                    % Alter this if needed
                    list = "first";
                    if index > numel(cellvec{currentlayer,1})
               
                        index = index - numel(cellvec{currentlayer,1});
                        list = "second";
                
                    end
                    
                    if duplicatecheck(i, index, list, cellvec{currentlayer,1}, cellvec{currentlayer,2}) == 0
                
                        % Add the new edge, checking which list it came from
                        if list == "first"

                            cellvec{currentlayer,1} = [cellvec{currentlayer,1}, i];
                            cellvec{currentlayer,2} = [cellvec{currentlayer,2}, cellvec{currentlayer,1}(index)];
                            remaining = remaining - 1;

                        else

                            cellvec{currentlayer,1} = [cellvec{currentlayer,1}, i];
                            cellvec{currentlayer,2} = [cellvec{currentlayer,2}, cellvec{currentlayer,2}(index)];
                            remaining = remaining - 1;

                        end
                
                    end 
                    
                end
                
            else
                
                % The node did not pass the sampling and the above code
                % will not execute on the next loop
                nodeactive = "False";
                
            end
            
            % Increase the current layer by 1 to ensure we do not add nodes
            % to a number of layers greater than M
            currentlayer = currentlayer + 1;
            
        end
        
    end
    
    % Now create a new cell array where the cells are the corresponding
    % adjacency matrices for each layer
    adjmats = cell(M,1);
    
    % Now build the matrices in a loop for each layer
    for k=1:M
       
        adjmats{k,1} = sparse(cellvec{k,1}, cellvec{k,2}, 1, N, N);
        adjmats{k,1} = adjmats{k,1} + adjmats{k,1}';
        
    end
    
end