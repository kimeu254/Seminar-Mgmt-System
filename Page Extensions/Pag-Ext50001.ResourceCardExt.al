/// <summary>
/// PageExtension Resource Card Ext (ID 50001) extends Record Resource Card.
/// </summary>
pageextension 50001 "Resource Card Ext" extends "Resource Card"
{
    layout
    {
        modify(Type)
        {
            trigger OnAfterValidate()

            begin
                EnableControls();
            end;
        }
        addafter(Type)
        {
            field("Internal/External"; Rec."Internal/External")
            {
                ApplicationArea = All;
            }
        }
        addafter("Personal Data")
        {
            group(Room)
            {
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()

    begin
        EnableControls();
    end;

    var
        Room: Boolean;

    /// <summary>
    /// EnableControls.
    /// </summary>
    procedure EnableControls()
    begin
        Room := Rec.IsRoom();
    end;
}
