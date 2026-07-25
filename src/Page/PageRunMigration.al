page 65020 "Rec Lancer Migration"
{
    Caption = 'Lancer Migration Texte';
    PageType = Card;
    UsageCategory = Administration;
    ApplicationArea = All;

    actions
    {
        area(Processing)
        {
            action(LancerMigration)
            {
                Caption = 'Lancer Migration';
                Image = Start;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Codeunit.Run(65010);
                end;
            }
        }
    }
}