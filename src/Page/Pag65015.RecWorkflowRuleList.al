page 65015 "Rec Workflow Rule Applied List"
{
    ApplicationArea = All;
    Caption = 'RecWorkflowRuleList';
    PageType = List;
    SourceTable = "Rec Workflow Rule";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Ordre Evaluation"; Rec."Ordre Evaluation") { ApplicationArea = All; }
            }
        }

    }
}
