% A function to check if a given index, would lead to a multiple edge, must
% be called twice to check fully
function dupe = dupeedge(index, ialpha, jalpha, ibeta, jbeta)

    % Set the return value to 0 to begin with
    dupe = 0;
    
    % Find the pair of nodes that the index refers to in alpha
    i = ialpha(index);
    j = jalpha(index);
    
    % Create a list of the indexes where i exists in beta if at all
    indexlist = find(ibeta == i);
    
    % Test to see if this is a scalar or a list
    if numel(indexlist) == 1
        
        % Then it only appears once, so test if the value of j is the same
        if j == jbeta(indexlist)
            
            dupe = 1;
            
        end
        
    elseif numel(indexlist) > 1
        
        for h=1:numel(indexlist)
                   
            if jbeta(indexlist(h)) == j
                        
                dupe = 1;
                        
            end
                    
        end

    end
    
end