/// <summary>
/// Report Seminar Reg.-Participant List (ID 50000).
/// </summary>
report 50000 "Seminar Reg.-Participant List"
{
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Seminar Reg.-Participant List.rdl';
    Caption = 'Seminar Reg.-Participant List';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(SeminarRegistrationHeader; "Seminar Registration Header")
        {
            DataItemTableView = SORTING("No.") WHERE("No." = FILTER(<> ''));
            RequestFilterFields = "No.";
            PrintOnlyIfDetail = false;
            column(No; "No.")
            {
            }
            column(StartingDate; "Starting Date")
            {
            }
            column(End_Date; "End Date")
            {
            }
            column(SeminarNo; "Seminar No.")
            {
            }
            column(SeminarName; "Seminar Name")
            {
            }
            column(InstructorName; "Instructor Name")
            {
            }
            column(Duration; Duration)
            {
            }
            column(RoomName; "Room Name")
            {
            }
            column(RoomAddress; "Room Address")
            {
            }
            column(RoomAddress2; "Room Address 2")
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyAddress2; CompanyInfo."Address 2")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            dataitem("Seminar Registration Line"; "Seminar Registration Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                DataItemLinkReference = SeminarRegistrationHeader;
                PrintOnlyIfDetail = false;
                column(Bill_to_Customer_No_; "Bill-to Customer No.")
                {
                    IncludeCaption = true;
                }
                column(Participant_Contact_No_; "Participant Contact No.")
                {
                    IncludeCaption = true;
                }
                column(Participant_Name; "Participant Name")
                {
                    IncludeCaption = true;
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[100];
}
