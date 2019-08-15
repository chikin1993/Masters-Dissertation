% A function to generate a 2 layer network using the GR model, takes N as
% final number of nodes, m_0 as the number to start with, m as the number
% of edges and values of p and q to tune the model, values from the unit 
% interval.
% ***This version uses a random starting layer***
function [alpha, beta] = GRmod_rand(N, m_0, m, p ,q)
    
    % Create 4 vectors to serve as edge lists for the 2 layers
    ialpha = [];
    jalpha = [];
    ibeta = [];
    jbeta = [];
    
    % Firtly we need to create the starting seed network to grow from,
    % currently this just a small cycle
    for i=1:m_0-1
        
        ialpha = [ialpha, i];
        jalpha = [jalpha, i+1];
        ibeta = [ibeta, i];
        jbeta = [jbeta, i+1];
        
    end
    
    % Adding these edges to close the starting loop
    ialpha = [ialpha, m_0];
    jalpha = [jalpha, 1];
    ibeta = [ibeta, m_0];
    jbeta = [jbeta, 1];
    
    % Now need to loop over adding nodes until we have N nodes in total
    for i=m_0+1:N
        
        % Sample a random integer to see which layer the node will be added
        % to first
        startlayer = randi(2);
        
        % Now depending on this value, the node is added to the
        % corresponding starting layer, the code is mostly the same and
        % reused for the alternate case.
        if startlayer == 1
        
            % Loop over m while sampling a random variable to compare to p each
            % time to determine the partition of edges
            m_1 = 0;
            m_2 = 0;
            for j = 1:m

                % Loop over and use counters to determine the values of m_2 and
                % m_2 for this node
                sample = rand();
                if sample < p                
                    m_1 = m_1 + 1;                
                else                
                    m_2 = m_2 + 1;               
                end

            end

            % Add edges to the first layer by preferential attachment
            addedalpha = 0;
            while addedalpha < m_1

                % This needs to pick nodes, prefering nodes with a higher
                % degree but retry in the case where a multi-edge would be
                % formed, so node index would correspond to a uniformly chosen
                % end-point
                index = randi(2*numel(ialpha));

                % See which list this value is in, and alter it if needed so we
                % can more easily find its corresponding node, noting which
                % list it was from
                list = "first";
                if index > numel(ialpha)

                    index = index - numel(ialpha);
                    list = "second";

                end

                % Now call the function to check if this index would lead to a
                % multiple edge
                if duplicatecheck(i, index, list, ialpha, jalpha) == 0

                    % Add the new edge, checking which list it came from
                    if list == "first"

                        ialpha = [ialpha, i];
                        jalpha = [jalpha, ialpha(index)];
                        addedalpha = addedalpha + 1;

                    else

                        ialpha = [ialpha, i];
                        jalpha = [jalpha, jalpha(index)];
                        addedalpha = addedalpha + 1;

                    end

                end

            end

            % Now we need to allocate the m_2 edges for layer 2. This is first
            % done by seeing how many edges will need to be replicated
            m_r = 0;
            for l = 1:numel(find(ialpha == i))

                % Loop over and use counters to determine the number of edges
                % required to be reinforced
                sample = rand();
                if sample < q                
                    m_r = m_r + 1;                               
                end

            end

            % We know how many edges we have to replicate, so create a
            % list by sampling uniformly at random from the new edges, without
            % replacement
            newedges = find(ialpha == i);
            newedgesperm = randsample(newedges, m_r);
            for o=1:m_r

                ibeta = [ibeta, ialpha(newedgesperm(o))];
                jbeta = [jbeta, jalpha(newedgesperm(o))];

            end

            % Now we need to add any leftover edges to layer 2 if we have them
            m_3 = m_2 - m_r;
            while m_3 > 0

                % This needs to pick nodes, prefering nodes with a higher
                % degree but retry in the case where a multi-edge would be
                % formed, so node index would correspond to a uniformly chosen
                % end-point
                index = randi(2*numel(ibeta));

                % See which list this value is in, and alter it if needed so we
                % can more easily find its corresponding node, noting which
                % list it was from
                list = "first";
                if index > numel(ibeta)

                    index = index - numel(ibeta);
                    list = "second";

                end

                % Now call the function to check if this index would lead to a
                % multiple edge
                if duplicatecheck(i, index, list, ibeta, jbeta) == 0

                    % Add the new edge, checking which list it came from
                    if list == "first"

                        ibeta = [ibeta, i];
                        jbeta = [jbeta, ibeta(index)];
                        m_3 = m_3 - 1;

                    else

                        ibeta = [ibeta, i];
                        jbeta = [jbeta, jbeta(index)];
                        m_3 = m_3 - 1;

                    end

                end            

            end
            
        else
            
            % Loop over m while sampling a random variable to compare to p each
            % time to determine the partition of edges
            m_1 = 0;
            m_2 = 0;
            for j = 1:m

                % Loop over and use counters to determine the values of m_2 and
                % m_2 for this node
                sample = rand();
                if sample < p                
                    m_1 = m_1 + 1;                
                else                
                    m_2 = m_2 + 1;               
                end

            end

            % Add edges to the first layer by preferential attachment
            addedalpha = 0;
            while addedalpha < m_1

                % This needs to pick nodes, prefering nodes with a higher
                % degree but retry in the case where a multi-edge would be
                % formed, so node index would correspond to a uniformly chosen
                % end-point
                index = randi(2*numel(ibeta));

                % See which list this value is in, and alter it if needed so we
                % can more easily find its corresponding node, noting which
                % list it was from
                list = "first";
                if index > numel(ibeta)

                    index = index - numel(ibeta);
                    list = "second";

                end

                % Now call the function to check if this index would lead to a
                % multiple edge
                if duplicatecheck(i, index, list, ibeta, jbeta) == 0

                    % Add the new edge, checking which list it came from
                    if list == "first"

                        ibeta = [ibeta, i];
                        jbeta = [jbeta, ibeta(index)];
                        addedalpha = addedalpha + 1;

                    else

                        ibeta = [ibeta, i];
                        jbeta = [jbeta, jbeta(index)];
                        addedalpha = addedalpha + 1;

                    end

                end

            end

            % Now we need to allocate the m_2 edges for layer 2. This is first
            % done by seeing how many edges will need to be replicated
            m_r = 0;
            for l = 1:numel(find(ibeta == i))

                % Loop over and use counters to determine the number of edges
                % required to be reinforced
                sample = rand();
                if sample < q                
                    m_r = m_r + 1;                               
                end

            end

            % We know how many edges we have to replicate, so create a
            % list by sampling uniformly at random from the new edges, without
            % replacement
            newedges = find(ibeta == i);
            newedgesperm = randsample(newedges, m_r);
            for o=1:m_r

                ialpha = [ialpha, ibeta(newedgesperm(o))];
                jalpha = [jalpha, jbeta(newedgesperm(o))];

            end

            % Now we need to add any leftover edges to layer 2 if we have them
            m_3 = m_2 - m_r;
            while m_3 > 0

                % This needs to pick nodes, prefering nodes with a higher
                % degree but retry in the case where a multi-edge would be
                % formed, so node index would correspond to a uniformly chosen
                % end-point
                index = randi(2*numel(ialpha));

                % See which list this value is in, and alter it if needed so we
                % can more easily find its corresponding node, noting which
                % list it was from
                list = "first";
                if index > numel(ialpha)

                    index = index - numel(ialpha);
                    list = "second";

                end

                % Now call the function to check if this index would lead to a
                % multiple edge
                if duplicatecheck(i, index, list, ialpha, jalpha) == 0

                    % Add the new edge, checking which list it came from
                    if list == "first"

                        ialpha = [ialpha, i];
                        jalpha = [jalpha, ialpha(index)];
                        m_3 = m_3 - 1;

                    else

                        ialpha = [ialpha, i];
                        jalpha = [jalpha, jalpha(index)];
                        m_3 = m_3 - 1;

                    end

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