function val = setDebug(newval)
    persistent currentval;
    if nargin >= 1
        currentval = newval;
    end
    val = currentval;
end
