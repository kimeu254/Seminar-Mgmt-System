/// <summary>
/// PageExtension Resource Ledger Entries Ext. (ID 50004) extends Record Resource Ledger Entries.
/// </summary>
pageextension 50004 "Resource Ledger Entries Ext." extends "Resource Ledger Entries"
{
    layout
    {
        addbefore("Job No.")
        {
            field("Seminar No."; Rec."Seminar No.")
            {
                ApplicationArea = All;
            }
            field("Seminar Registration No."; Rec."Seminar Registration No.")
            {
                ApplicationArea = All;
            }

        }
    }
}
