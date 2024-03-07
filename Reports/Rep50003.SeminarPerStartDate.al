report 50003 "Seminar Per StartDate"
{
    ApplicationArea = All;
    Caption = 'Seminar Per Date';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SeminarPerDate.rdl';

    dataset
    {
        dataitem(SeminarRegistrationHeader; "Seminar Registration Header")
        {
            RequestFilterFields = "Starting Date";

            column(No; "No.")
            {
            }
            column(StartingDate; "Starting Date")
            {
            }
            column(EndDate; "End Date")
            {
            }
            column(SeminarNo; "Seminar No.")
            {
            }
            column(SeminarName; "Seminar Name")
            {
            }
            column(InstructorResourceNo; "Instructor Resource No.")
            {
            }
            column(InstructorName; "Instructor Name")
            {
            }
            column(RoomResourceNo; "Room Resource No.")
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
            column(RoomCity; "Room City")
            {
            }
            column(SeminarPrice; "Seminar Price")
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
            column(NoParticipants; NoParticipants)
            {
            }
            dataitem(Resource; Resource)
            {
                DataItemLink = "No." = field("Room Resource No.");
                DataItemLinkReference = SeminarRegistrationHeader;
                DataItemTableView = sorting("No.") order(ascending);
                column(Maximum_Participants; "Maximum Participants")
                {
                }
            }
            trigger OnAfterGetRecord()
            begin
                NoParticipants := 0;

                SeminarRegLine.Reset();
                SeminarRegLine.SetRange("Document No.", "No.");
                if SeminarRegLine.FindSet() then
                    NoParticipants := SeminarRegLine.Count;
            end;
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
        SeminarRegLine: Record "Seminar Registration Line";
        CompanyAddr: array[8] of Text[100];
        NoParticipants: Integer;
}
