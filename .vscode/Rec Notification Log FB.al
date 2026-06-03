page 65013 "Rec Notification Log FB"
{
    Caption = 'Notifications';
    PageType = ListPart;
    SourceTable = "Rec Notification Log";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Date Heure"; Rec."Date Heure")
                {
                    ApplicationArea = All;
                    Caption = 'Date / Heure';
                }
                field("Type Notification"; Rec."Type Notification")
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    StyleExpr = TypeStyle;
                }
                field(Message; Rec.Message)
                {
                    ApplicationArea = All;
                    Caption = 'Message';
                }
                field(Destinataire; Rec.Destinataire)
                {
                    ApplicationArea = All;
                    Caption = 'Destinataire';
                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = All;
                    Caption = 'Traité';
                    StyleExpr = ProcessedStyle;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        case Rec."Type Notification" of
            Rec."Type Notification"::"Hors SLA",
            Rec."Type Notification"::"Escalade Manager":
                TypeStyle := 'Unfavorable';
            Rec."Type Notification"::Alerte75pct:
                TypeStyle := 'Ambiguous';
            Rec."Type Notification"::"Confirmation Client",
            Rec."Type Notification"::Satisfaction,
            Rec."Type Notification"::Cloture:
                TypeStyle := 'Favorable';
            else
                TypeStyle := 'Standard';
        end;

        if Rec.Processed then
            ProcessedStyle := 'Favorable'
        else
            ProcessedStyle := 'Ambiguous';
    end;

    var
        TypeStyle: Text;
        ProcessedStyle: Text;
}