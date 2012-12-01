function partitioninds = do_partition(sequence,CHUNKSIZE)
%partition the sequence 1:LEN into chunks of size CHUNKSIZE
%Tomasz Malisiewicz
LEN = length(sequence);
starts = 1:CHUNKSIZE:(LEN+CHUNKSIZE);

for i = 1:length(starts)-1
  partitioninds{i} = sequence(starts(i):min(LEN,starts(i+1)-1));
end

