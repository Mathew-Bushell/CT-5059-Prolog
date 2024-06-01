%recursively loops through the connective list until
connective([H|T],EmailList):-
   delete(EmailList, H, EmailList2),
   connective(T,EmailList2).
%ends the recursive loop once the list is empty
connective([],EmailList):-
   nl,
   %write(EmailList),
   count_all(EmailList),
   !.
%Opens file location and reads each character one by one from stream
read_file(File) :-
   open(File, read, Stream),
   get_char(Stream, Char1),
   process_stream(Char1, Stream, ""),
   close(Stream).

%ends recursion if end of file is met
process_stream(end_of_file, _, StrWord) :-
   nl,
   string_lower(StrWord,StrLowerCase),
   split_string(StrLowerCase," ", "",SplitString),
%   write(StrLowerCase),
%   write(SplitString),
   nl,
   connective(["a","an","the","for","and","nor","but","or","yet","so","to","at","by","from","in","into","of","on","onto","with","as","than","up","down","off","out","over","under","above","about","after","around","before","through","throughout","therefore","nonetheless","whereas","finally","furthermore","until","upon","within","am","thus","however"],SplitString),


   !.

%is responsible for reading each char
process_stream(Char, Stream, StrWord):-
  % write(Char),
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
   name(StrWord, ListWord),
   (   Char = ',' ->
       name(StrWord2, ListWord)

       ;
       (  Char = '.' ->
          name(StrWord2,ListWord)

       ;
          (   Char = '\n' ->
             append(ListWord, [32], ListWord2),
             name(StrWord2, ListWord2)

          ;

                name(Char, CharList),
                append(ListWord, CharList, ListWord2),
                name(StrWord2, ListWord2)

          )
       )
   ).
%This will count the number of occurences of each word in the email
%Sorting removes all duplicate elements
count_all(EmailList):-
   sort(EmailList,SortedEmail),
   member(Target,SortedEmail),
   count_occurence(EmailList,Target,0,"",SortedEmail,EmailList).

%When an occurence is found it adds one to the occurence count
count_occurence([H|T],Target,Count,CountedList,SortedEmail,EmailList):-
   (   H = Target ->
      NewCount is Count + 1,
      count_occurence(T,Target,NewCount,CountedList,SortedEmail,EmailList)
   ;
      count_occurence(T,Target,Count,CountedList,SortedEmail,EmailList)
   )
   .


% when there are no more words to search it adds the count of words to
% the counted str and then starts again with the next target word
count_occurence([],Target,Count,CountedStr,[H|SortedEmail],EmailList):-
   ListAdd = [],
   delete(EmailList,Target,EmailList1),
   name(CountedStr,CountedList),
   name(Count,CountList),
   name(Target,TargetAdd),
   append(ListAdd,CountList,ListAdd1),
   append(ListAdd1,[61],ListAdd2),
   append(ListAdd2,TargetAdd,ListAdd3),
   append(ListAdd3,[32],ListAdd4),
   append(CountedList,ListAdd4,CountedList1),
   name(CountedStr1,CountedList1),
  % write(CountedStr1),
   member(NewTarget,SortedEmail),
   %if there are no more target words the recursion will stop
   (   SortedEmail = ["you"] -> %This is an adhock fix which means it will
   %miss out you in the final count but has been the only way so far I
   %have found to stop the recursion.

      split_string(CountedStr," ","",FinalList),
      sort(FinalList,FinalList1),
      reverse(FinalList1,FinalList2),
     % write(FinalList2),
      final_print(FinalList2,0,Score),
      !
      ;
      count_occurence(EmailList1,NewTarget,0,CountedStr1,SortedEmail,EmailList1)
   ).
% uses recursion to loop 10 times and print the top 10 items of the
% reversed list stoping once it reaches 10 iterations.
% Score is leftover from begining to implement part C, implementation
% was halted due to lack of time.
final_print(FinalList,10,Score):-
   !.

final_print([H|FinalList],I,Score):-
   write(H),
   nl,
   NewI is I + 1,

   final_print(FinalList,NewI,Score).

