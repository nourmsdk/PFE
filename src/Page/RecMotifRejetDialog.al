page 65018 "Rec Motif Rejet Dialog"
{
    PageType = StandardDialog;
    Caption = 'Motif du rejet';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field(Motif; Motif)
            {
                ApplicationArea = All;
                Caption = 'Motif du rejet';
                MultiLine = true;
                ToolTip = 'Commentaire obligatoire expliquant le rejet vers Investigation.';
            }
        }
    }

    var
        Motif: Text[250];

    procedure GetMotif(): Text[250]
    begin
        exit(Motif);
    end;
}
