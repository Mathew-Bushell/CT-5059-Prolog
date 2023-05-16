:-use_module(library(filesex)).

% I'm using strings wherever there is supposed to be "text whose only meaning is itself"

perform_catch(Terms,Encoding) :-
   catch(perform(Terms,Encoding),ExceptionTerm,(format(user_error,"~q",[ExceptionTerm]),fail)).

perform(Terms,Encoding) :-
   WhereDir = "D:/Users/mathe/github/CT-5059-Prolog",
 %  directory_file_path(WhereDir,"prepacked",PrepackedDir),
 %  directory_file_path(PrepackedDir,"onepointfour",D1), % directory_file_path has bugs so go step by step here
 %  directory_file_path(D1,"basics",D2), % directory_file_path has bugs so go step by step here
   directory_file_path(WhereDir,"Email.txt",File),
   exists_file_or_throw(File),
   open_or_throw(File,Stream,Encoding),
   assertion(is_stream(Stream)),
   % Exceptions due to syntax problems are left to bubble "up".
   % If this happens in an interactive sessions, the tracer is triggered
   % (unless you did "set_prolog_flag(debug_on_error,false)") and stops
   % right before the cleanup goal
   setup_call_cleanup(
      true,
      slurp_terms(Stream,Terms),
      (format(user_error,"Closing ~q~n",[File]),close(Stream))),
   assertion(\+is_stream(Stream)).

% ---

slurp_terms(Stream,Terms) :-
   read_term(Stream,Term,[]),  % will throw on syntax error; unifies Term with "end_of_file" at EOF
   slurp_terms_again(Term,Stream,Terms).

% ---

slurp_terms_again(end_of_file,_Stream,[]) :- !.
slurp_terms_again(Term,Stream,[Term|Terms]) :-
   slurp_terms(Stream,Terms).

% ---

open_or_throw(File,Stream,Encoding) :-
   open(File,read,Stream,[encoding(Encoding)]),
   !.

open_or_throw(File,_Stream,_Encoding) :-
   domain_error("Opening file for reading failed",File). % but how do I know WHY it failed?

% ---

exists_file_or_throw(File) :-
   exists_file(File),!.

exists_file_or_throw(File) :-
   domain_error("No such file",File). % domain error is as good as any
