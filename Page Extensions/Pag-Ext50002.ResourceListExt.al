/// <summary>
/// PageExtension Resource List Ext (ID 50002) extends Record Resource List.
/// </summary>
pageextension 50002 "Resource List Ext" extends "Resource List"
{
    layout
    {
        modify(Type)
        {
            Visible = ShowType;
        }
        addafter(Type)
        {
            field("Internal/External"; Rec."Internal/External")
            {
                ApplicationArea = All;
            }
            field(ShowMaxParticipants; ShowMaxParticipants)
            {
                Visible = ShowMaxParticipants;
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FILTERGROUP(3);
        ShowType := Rec.GETFILTER(Type) = '';
        ShowMaxParticipants := Rec.GETFILTER(Type) = FORMAT(Rec.Type::Machine);
        Rec.FILTERGROUP(0);
    end;

    var
        ShowType: Boolean;
        ShowMaxParticipants: Boolean;
}
