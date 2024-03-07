/// <summary>
/// PageExtension Source Code Setup Extension (ID 50003) extends Record Source Code Setup.
/// </summary>
pageextension 50003 "Source Code Setup Extension" extends "Source Code Setup"
{
    layout
    {
        addlast(content)
        {
            group("Seminar Management")
            {
                Caption = 'Seminar Management';
                field(Seminar; Rec.Seminar)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
