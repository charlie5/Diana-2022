--  Diana.Interpreter — a first tree interpreter for DIANA_2022.
--
--  It walks a DIANA tree through the generated Diana.Accessors and executes it,
--  evaluating expressions to the Static_Value model and running statements.
--  This is the third harness requirement: execute a given DIANA tree, and error
--  out (Interpretation_Error) if execution cannot be completed.
--
--  First slice (integer-valued): literals, variable references, built-in
--  operator calls (arithmetic + comparison), assignment, if-statements,
--  while-loops, statement sequences, and Put_Line output.  Unsupported nodes
--  raise Interpretation_Error rather than failing silently.

package Diana.Interpreter is

   --  Execute the statement (or Statement_S sequence) at Statements, starting
   --  from a fresh, empty environment.
   procedure Run (Statements : Cursor);

   --  Raised when a tree cannot be executed (an unbound name, an unsupported
   --  node, a type mismatch in the value model, ...).
   Interpretation_Error : exception;

   --  Raised when a runtime contract check fails: a pragma Assert, or a
   --  subprogram precondition (Pre) or postcondition (Post).  The program is
   --  wrong, as opposed to the interpreter being unable to proceed.
   Assertion_Error : exception;

end Diana.Interpreter;
