Main Requirement: Look at the DIANA LRM and the Ada 2022 LRM and generate an updated (but backwards compatible) DIANA IR.

 ● Specifications:
 
  ○ Historical:
   - DIANA:
    ■ Rev 3: https://apps.dtic.mil/sti/pdfs/ADA128232.pdf
    ■ Draft of Rev 4: https://apps.dtic.mil/sti/tr/pdf/ADA272792.pdf
   - IDL:
    ■ https://queensu.scholaris.ca/bitstreams/d5567e9e-f517-452b-b6cb-086fe9744915/download
    
  ○ Ada
   - Ada83:
    ■ Standard: http://archive.adaic.com/standards/83lrm/html/
    ■ Rationale: http://archive.adaic.com/standards/83rat/html/
   - Ada 2022:
    ■ http://www.ada-auth.org/standards/22rm_w_amd1/RM-Final.pdf
    
 ● Instructions:
  ○ Maintain backwards comparability with the original DIANA specification.
   - Use RENAMES to present the shortened DIANA Rev 3/4 style node names, but the original should follow the style below.
  ○ Define new nodes for the new syntax and semantics of Ada 2022.
  ○ Constructs that Ada defines as semantically equivalent should typically be a single construct in DIANA; example “Return 0;” and “Return Value : Integer := 0;” and the full extended return.
  ○ Also create an interpretive test harness to execute given DIANA;
   - It should error out if it cannot be done (eg missing separate compilation).
   - It should provide a way to merge in separately compiled DIANA.
   
 ● Style:
  ○ Identifiers: Initial capitals, underscore separated, full-word or all-capital acronym.
  ○ In general, aspects and attributes are syntactic constructs for the same semantic property (ex. "with Size => 8" and "For Some_Type'Size use 8;"), therefore aspects and attribute definition clauses should "boil down" to the same construct within the DIANA (the differentiation being perhaps a single boolean note-attribute detailing if the property came from an attribute definition clause or an aspect).
  ○ Comments regarding where the construction comes from, whether DIANA RM, or the Ada RM.
