function evalCallbacks(h)

names = fieldnames(h);

for i = 1 : length(names)
    field = h.(char(names(i)));
    if isprop(field,'callback')
        callback = get(h.fields(i),'callback');
        hgfeval(callback)
    end
end

end