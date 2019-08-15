% A function to check if an edge can be created between a new node i and
% one chosen at random from the index lists
function dupe = duplicatecheck(i, index, list, ilist, jlist)

    % Set the return value to 0 to begin with
    dupe = 0;
    
    % Find the node the index is referring to
    if list == "first"
       
        j = ilist(index);
        
    else 
        
        j = jlist(index);
        
    end
    
    % This just to check if this is a self loop
    if i == j

            dupe = 1;
            
    end
    
    % Create 2 lists of the indexes where i is present, this is done for
    % both lists
    iindex = find(ilist == i);
    jindex = find(jlist == i);
    
    % Now test to see if the first contains a duplicate
    if numel(iindex) == 1

        % Then it only appears once, so test if the value of j is the same
        if j == jlist(iindex)

            dupe = 1;

        end

    elseif numel(iindex) > 1

        for h=1:numel(iindex)

            if jlist(iindex(h)) == j

                dupe = 1;              

            end

        end

    end
    
    % Now test to see if the second contains a duplicate
    if numel(jindex) == 1

        % Then it only appears once, so test if the value of j is the same
        if j == ilist(jindex)

            dupe = 1;

        end

    elseif numel(jindex) > 1

        for h=1:numel(jindex)

            if ilist(jindex(h)) == j

                dupe = 1;              

            end

        end

    end

end
