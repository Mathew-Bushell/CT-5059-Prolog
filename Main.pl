%Opens file location and reads each character one by one from stream
read_file(File, StrWord) :-
   open(File, read, Stream),
   get_char(Stream, Char1),
   process_stream(Char1, Stream, StrWord),
   close(Stream).

%ends recursion if end of file is met
process_stream(end_of_file, _, StrWord) :-
   write(StrWord),
   !.

%is responsible for reading each char
process_stream(Char, Stream, StrWord):-
   write(Char),

   add_to_word(Char, StrWord, StrWord2),

   get_char(Stream,Char2),
   process_stream(Char2, Stream, StrWord2).

%writes to file, temporarily exsists for testing purpose
write_to_file(File, Text) :-
   open(File, write, Stream),
   write(Stream, Text), nl,
   close(Stream).

add_to_word(Char, StrWord, StrWord2):-
   %Converts strings to list, combines them and then converts back to string
   name(Char, CharList),
   name(StrWord, ListWord),
   append(ListWord, CharList, ListWord2),
   name(StrWord2, ListWord2).

