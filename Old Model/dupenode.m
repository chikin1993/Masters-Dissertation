% A function that is given a node
function dupe = dupenode(index, ialpha, jalpha, i, list)

    % Set the return value to 0 to begin with
    dupe = 0;
    


        % Test to see if this is a scalar or a list
        if numel(indexlist) == 1

            % Then it only appears once, so test if the value of j is the same
            if j == jalpha(indexlist)

                dupe = 1;

            end

        elseif numel(indexlist) > 1

            for h=1:numel(indexlist)

                if jalpha(indexlist(h)) == j

                    dupe = 1;              

                end
                
            end
            
        end
        
    else
        
        j = jalpha(index);
    
        % Create a list of the indexes where i exists in alpha if at all
        indexlist = find(jalpha == i);

        % Check to see if this is a self-loop
        if i == j

            dupe = 1;
            
        end

        % Test to see if this is a scalar or a list
        if numel(indexlist) == 1

            % Then it only appears once, so test if the value of j is the same
            if j == ialpha(indexlist)

                dupe = 1;

            end

        elseif numel(indexlist) > 1

            for h=1:numel(indexlist)

                if ialpha(indexlist(h)) == j

                    dupe = 1;              

                end
                
            end
            
        end
        
    end

end