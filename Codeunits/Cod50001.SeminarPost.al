/// <summary>
/// Codeunit Seminar Post (ID 50001).
/// </summary>
codeunit 50001 "Seminar Post"
{
    TableNo = "Seminar Registration Header";

    VAR
        SeminarRegHeader: Record "Seminar Registration Header";
        SeminarRegLine: Record "Seminar Registration Line";
        PstdSeminarRegHeader: Record "Posted Seminar Reg. Header";
        PstdSeminarRegLine: Record "Posted Seminar Reg. Line";
        SeminarCommentLine: Record "Seminar Comment Line";
        SeminarCommentLine2: Record "Seminar Comment Line";
        SeminarCharge: Record "Seminar Charge";
        PstdSeminarCharge: Record "Posted Seminar Charge";
        Room: Record Resource;
        Instructor: Record Resource;
        Customer: Record Customer;
        ResLedgEntry: Record "Res. Ledger Entry";
        SeminarJnlLine: Record "Seminar Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        ResJnlLine: Record "Res. Journal Line";
        SeminarJnlPostLine: Codeunit "Seminar Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CurrencyExch: Record "Currency Exchange Rate";
        SalesDis: Codeunit "Sales - Calc Discount By Type";
        SalePost: Codeunit "Sales-Post";
        NoOfSalesInvErr: Integer;
        NoOfSalesInv: Integer;
        NextLineNo: Integer;
        Window: Dialog;
        SourceCode: Code[10];
        LineCount: Integer;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        FileMgmt: Codeunit "File Management";
        InStr: InStream;
        OutStr: OutStream;
        txtB64: Text;
        NoParticipantErr: Label 'There is no participant to post.';
        PostingLineNoTxt: Label 'Posting lines              #2######\';
        Text003: Label 'Registration';
        Text004: Label 'Registration %1  -> Posted Reg. %2';
        Text005: Label 'The combination of dimensions used in %1 is blocked. %2';
        Text006: Label 'The combination of dimensions used in %1, line no. %2 is blocked. %3';
        Text007: Label 'The dimensions used in %1 are invalid. %2';
        Text008: Label 'The dimensions used in %1, line no. %2 are invalid. %3';

    trigger OnRun()
    begin
        CLEARALL;
        SeminarRegHeader := Rec;
        SeminarRegHeader.TESTFIELD("Posting Date");
        SeminarRegHeader.TESTFIELD("Document Date");
        SeminarRegHeader.TESTFIELD("Seminar No.");
        SeminarRegHeader.TESTFIELD(Duration);
        SeminarRegHeader.TESTFIELD("Instructor Resource No.");
        SeminarRegHeader.TESTFIELD("Room Resource No.");
        SeminarRegHeader.TESTFIELD(Status, SeminarRegHeader.Status::Closed);
        SeminarRegHeader.TestField("Approval Status", SeminarRegHeader."Approval Status"::Released);

        SeminarRegLine.RESET;
        SeminarRegLine.SETRANGE("Document No.", Rec."No.");
        IF SeminarRegLine.ISEMPTY THEN
            ERROR(NoParticipantErr);

        Window.OPEN(
          '#1#################################\\' +
           PostingLineNoTxt);
        Window.UPDATE(1, STRSUBSTNO('%1 %2', Text003, Rec."No."));

        IF SeminarRegHeader."Posting No." = '' THEN BEGIN
            Rec.TESTFIELD("Posting No. Series");
            Rec."Posting No." := NoSeriesMgt.GetNextNo(Rec."Posting No. Series", Rec."Posting Date", TRUE);
            Rec.MODIFY;
            COMMIT;
        END;
        SeminarRegLine.LOCKTABLE;

        SourceCodeSetup.GET;
        SourceCode := SourceCodeSetup.Seminar;

        PstdSeminarRegHeader.INIT;
        PstdSeminarRegHeader.TRANSFERFIELDS(SeminarRegHeader);
        PstdSeminarRegHeader."No." := Rec."Posting No.";
        PstdSeminarRegHeader."No. Series" := Rec."Posting No. Series";
        PstdSeminarRegHeader."Source Code" := SourceCode;
        PstdSeminarRegHeader."User ID" := USERID;
        PstdSeminarRegHeader.INSERT;

        Window.UPDATE(1, STRSUBSTNO(Text004, Rec."No.",
          PstdSeminarRegHeader."No."));

        CopyCommentLines(
          SeminarCommentLine."Document Type"::"Seminar Registration",
          SeminarCommentLine."Document Type"::"Posted Seminar Registration",
          Rec."No.", PstdSeminarRegHeader."No.");
        CopyCharges(Rec."No.", PstdSeminarRegHeader."No.");

        LineCount := 0;
        SeminarRegLine.RESET;
        SeminarRegLine.SETRANGE("Document No.", Rec."No.");
        IF SeminarRegLine.FINDSET THEN BEGIN
            REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(2, LineCount);

                SeminarRegLine.TESTFIELD("Bill-to Customer No.");
                SeminarRegLine.TESTFIELD("Participant Contact No.");
                SeminarRegLine.TESTFIELD("Participant E-Mail");

                IF NOT SeminarRegLine."To Invoice" THEN BEGIN
                    SeminarRegLine."Seminar Price" := 0;
                    SeminarRegLine."Line Discount %" := 0;
                    SeminarRegLine."Line Discount Amount" := 0;
                    SeminarRegLine.Amount := 0;
                END ELSE BEGIN
                    Customer.Get(SeminarRegLine."Bill-to Customer No.");
                    if Customer.Blocked in [Customer.Blocked::All, Customer.Blocked::Invoice] then begin
                        NoOfSalesInvErr += 1;
                    end else begin
                        InsertSalesInvHeader();

                        SalesLine."Document Type" := SalesHeader."Document Type";
                        SalesLine."Document No." := SalesHeader."No.";
                        SalesLine."Line No." := NextLineNo;
                        SalesLine.Type := SalesLine.Type::Resource;
                        SalesLine."No." := SeminarRegHeader."Instructor Resource No.";
                        SalesLine.Validate("No.");
                        SalesLine."Unit Price" := SeminarRegLine.Amount;

                        if (SalesHeader."Currency Code" <> '') then begin
                            SalesHeader.TESTFIELD("Currency Factor");
                            SalesLine."Unit Price" :=
                                ROUND(
                                    CurrencyExch.ExchangeAmtLCYToFCY(
                                        WORKDATE,
                                        SalesHeader."Currency Code",
                                        SalesLine."Unit Price",
                                        SalesHeader."Currency Factor"
                                    )
                                );
                        end;

                        SalesLine.Quantity := 1;
                        SalesLine.VALIDATE(Quantity);
                        SalesLine.INSERT;
                        NextLineNo := NextLineNo + 10000;

                        Clear(SalePost);
                        SalePost.Run(SalesHeader);
                    end;
                END;

                IF SeminarRegLine.Participated THEN begin
                    EmailCertificateToParticipants(SeminarRegLine."Document No.", SeminarRegLine."Line No.");
                end;

                // Post seminar entry
                PostSeminarJnlLine(SeminarJnlLine."Charge Type"::Participant); // Participant

                // Insert posted seminar registration line
                PstdSeminarRegLine.INIT;
                PstdSeminarRegLine.TRANSFERFIELDS(SeminarRegLine);
                PstdSeminarRegLine."Document No." := PstdSeminarRegHeader."No.";
                PstdSeminarRegLine.INSERT;
            UNTIL SeminarRegLine.NEXT = 0;
        END;

        // Post charges to seminar ledger
        PostCharges;

        // Post instructor to seminar ledger
        PostSeminarJnlLine(SeminarJnlLine."Charge Type"::Instructor); // Instructor

        // Post seminar room to seminar ledger
        PostSeminarJnlLine(SeminarJnlLine."Charge Type"::Room); // Room

        Rec.DELETE;
        SeminarRegLine.DELETEALL;

        SeminarCommentLine.SETRANGE("Document Type",
          SeminarCommentLine."Document Type"::"Seminar Registration");
        SeminarCommentLine.SETRANGE("No.", Rec."No.");
        SeminarCommentLine.DELETEALL;

        SeminarCharge.SETRANGE(Description);
        SeminarCharge.DELETEALL;
        Rec := SeminarRegHeader;
    end;

    LOCAL PROCEDURE CopyCommentLines(
        FromDocumentType: Enum "Seminar Comment Document Type";
        ToDocumentType: Enum "Seminar Comment Document Type";
        FromNumber: Code[20]; ToNumber: Code[20])
    BEGIN
        SeminarCommentLine.RESET;
        SeminarCommentLine.SETRANGE("Document Type", FromDocumentType);
        SeminarCommentLine.SETRANGE("No.", FromNumber);
        IF SeminarCommentLine.FINDSET(FALSE, FALSE) THEN BEGIN
            REPEAT
                SeminarCommentLine2 := SeminarCommentLine;
                SeminarCommentLine2."Document Type" := ToDocumentType;
                SeminarCommentLine2."No." := ToNumber;
                SeminarCommentLine2.INSERT;
            UNTIL SeminarCommentLine.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE CopyCharges(FromNumber: Code[20]; ToNumber: Code[20])
    BEGIN
        SeminarCharge.RESET;
        SeminarCharge.SETRANGE("Document No.", FromNumber);
        IF SeminarCharge.FINDSET(FALSE, FALSE) THEN BEGIN
            REPEAT
                PstdSeminarCharge.TRANSFERFIELDS(SeminarCharge);
                PstdSeminarCharge."Document No." := ToNumber;
                PstdSeminarCharge.INSERT;
            UNTIL SeminarCharge.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE PostResJnlLine(Resource: Record Resource): Integer
    BEGIN
        //Resource.TESTFIELD("Quantity Per Day");
        ResJnlLine.INIT;
        ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Usage;
        ResJnlLine."Document No." := PstdSeminarRegHeader."No.";
        ResJnlLine."Resource No." := Resource."No.";
        ResJnlLine."Posting Date" := SeminarRegHeader."Posting Date";
        ResJnlLine."Reason Code" := SeminarRegHeader."Reason Code";
        ResJnlLine.Description := SeminarRegHeader."Seminar Name";
        ResJnlLine."Gen. Prod. Posting Group" := SeminarRegHeader."Gen. Prod.  Posting Group";
        ResJnlLine."Posting No. Series" := SeminarRegHeader."Posting No. Series";
        ResJnlLine."Source Code" := SourceCode;
        ResJnlLine."Resource No." := Resource."No.";
        ResJnlLine."Unit of Measure Code" := Resource."Base Unit of Measure";
        ResJnlLine."Unit Cost" := Resource."Unit Cost";
        ResJnlLine."Qty. per Unit of Measure" := 1;
        //ResJnlLine.Quantity := SeminarRegHeader.Duration * Resource."Quantity Per Day";
        ResJnlLine."Total Cost" := ResJnlLine."Unit Cost" * ResJnlLine.Quantity;
        ResJnlLine."Seminar No." := SeminarRegHeader."Seminar No.";
        ResJnlLine."Seminar Registration No." := PstdSeminarRegHeader."No.";
        ResJnlPostLine.RunWithCheck(ResJnlLine);

        ResLedgEntry.FINDLAST;
        EXIT(ResLedgEntry."Entry No.");
    END;

    LOCAL PROCEDURE PostSeminarJnlLine(ChargeType: Enum "Seminar Journal Charge Type")
    BEGIN
        SeminarJnlLine.INIT;
        SeminarJnlLine."Seminar No." := SeminarRegHeader."Seminar No.";
        SeminarJnlLine."Posting Date" := SeminarRegHeader."Posting Date";
        SeminarJnlLine."Document Date" := SeminarRegHeader."Document Date";
        SeminarJnlLine."Document No." := PstdSeminarRegHeader."No.";
        SeminarJnlLine."Charge Type" := ChargeType;
        SeminarJnlLine."Instructor Resource No." := SeminarRegHeader."Instructor Resource No.";
        SeminarJnlLine."Starting Date" := SeminarRegHeader."Starting Date";
        SeminarJnlLine."End Date" := SeminarRegHeader."End Date";
        SeminarJnlLine."Seminar Registration No." := PstdSeminarRegHeader."No.";
        SeminarJnlLine."Room Resource No." := SeminarRegHeader."Room Resource No.";
        SeminarJnlLine."Source Type" := SeminarJnlLine."Source Type"::Seminar;
        SeminarJnlLine."Source No." := SeminarRegHeader."Seminar No.";
        SeminarJnlLine."Source Code" := SourceCode;
        SeminarJnlLine."Reason Code" := SeminarRegHeader."Reason Code";
        SeminarJnlLine."Posting No. Series" := SeminarRegHeader."Posting No. Series";
        CASE ChargeType OF
            ChargeType::Instructor:
                BEGIN
                    Instructor.GET(SeminarRegHeader."Instructor Resource No.");
                    SeminarJnlLine.Description := Instructor.Name;
                    SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                    SeminarJnlLine.Chargeable := FALSE;
                    SeminarJnlLine.Quantity := SeminarRegHeader.Duration;
                    SeminarJnlLine."Res. Ledger Entry No." := PostResJnlLine(Instructor);
                END;
            ChargeType::Room:
                BEGIN
                    Room.GET(SeminarRegHeader."Room Resource No.");
                    SeminarJnlLine.Description := Room.Name;
                    SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                    SeminarJnlLine.Chargeable := FALSE;
                    SeminarJnlLine.Quantity := SeminarRegHeader.Duration;
                    // Post to resource ledger
                    SeminarJnlLine."Res. Ledger Entry No." := PostResJnlLine(Room);
                END;
            ChargeType::Participant:
                BEGIN
                    SeminarJnlLine."Bill-to Customer No." := SeminarRegLine."Bill-to Customer No.";
                    SeminarJnlLine."Participant Contact No." := SeminarRegLine."Participant Contact No.";
                    SeminarJnlLine."Participant Name" := SeminarRegLine."Participant Name";
                    SeminarJnlLine.Description := SeminarRegLine."Participant Name";
                    SeminarJnlLine."Participant E-Mail" := SeminarRegLine."Participant E-Mail";
                    SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                    SeminarJnlLine.Chargeable := SeminarRegLine."To Invoice";
                    SeminarJnlLine.Quantity := 1;
                    SeminarJnlLine."Unit Price" := SeminarRegLine.Amount;
                    SeminarJnlLine."Total Price" := SeminarRegLine.Amount;
                END;
            ChargeType::Charge:
                BEGIN
                    SeminarJnlLine.Description := SeminarCharge.Description;
                    SeminarJnlLine."Bill-to Customer No." := SeminarCharge."Bill-to Customer No.";
                    SeminarJnlLine.Type := SeminarCharge.Type;
                    SeminarJnlLine.Quantity := SeminarCharge.Quantity;
                    SeminarJnlLine."Unit Price" := SeminarCharge."Unit Price";
                    SeminarJnlLine."Total Price" := SeminarCharge."Total Price";
                    SeminarJnlLine.Chargeable := SeminarCharge."To Invoice";
                END;
        END;

        SeminarJnlPostLine.RunWithCheck(SeminarJnlLine);
    END;

    LOCAL PROCEDURE PostCharges()
    BEGIN
        SeminarCharge.RESET;
        SeminarCharge.SETRANGE("Document No.", SeminarRegHeader."No.");
        IF SeminarCharge.FINDSET(FALSE, FALSE) THEN BEGIN
            REPEAT
                PostSeminarJnlLine(SeminarJnlLine."Charge Type"::Charge); // Charge
            UNTIL SeminarCharge.NEXT = 0;
        END;
    END;

    local procedure InsertSalesInvHeader()
    begin
        SalesHeader.init;
        SalesHeader."Document Type" := "Sales Document Type"::Invoice;
        SalesHeader."No." := '';
        SalesHeader.Insert(true);

        SalesHeader.Validate("Sell-to Customer No.", SeminarRegLine."Bill-to Customer No.");
        if (SalesHeader."Bill-to Customer No.") <> (SalesHeader."Sell-to Customer No.") then
            SalesHeader.Validate("Bill-to Customer No.", SeminarRegLine."Bill-to Customer No.");
        SalesHeader.Validate("Posting Date", WorkDate);
        SalesHeader.Validate("Document Date", WorkDate);
        SalesHeader.Validate("Currency Code");
        SalesHeader.modify;
        commit;
        NextLineNo := 10000;
    end;

    local procedure EmailCertificateToParticipants(DocNo: Code[20]; LineNo: Integer)
    var
        RecRef: RecordRef;
        SemRegLine: Record "Seminar Registration Line";
        Body: Text[1024];
        CompanyInfo: Record "Company Information";
    begin
        SemRegLine.Reset();
        SemRegLine.SetRange("Document No.", DocNo);
        SemRegLine.SetRange("Line No.", LineNo);
        SemRegLine.FindFirst();
        RecRef.GetTable(SemRegLine);

        TempBlob.CreateOutStream(OutStr);

        if Report.SaveAs(
            Report::"Certificate of Participation",
            '',
            ReportFormat::Pdf,
            OutStr,
            RecRef
        ) then begin
            TempBlob.CreateInStream(InStr);
            //txtB64 := cnv64.ToBase64(InStr, true);
            Body := 'Hello ' + SemRegLine."Participant Name" + ',';
            Body += '<p><br><br>PFA your certificate of participation.</p>';
            Body += '</p><br><br>Kind Regards,</p>';
            Body += '<p><br>' + CompanyInfo.Name + '.</p>';
            EmailMessage.Create(
                'jimmymutiso@dynasoft.co.ke',
                'CERTIFICATE OF PARTICIPATION',
                Body,
                false
            );

            EmailMessage.AddAttachment(
                'Participation Certificate.pdf',
                'PDF',
                InStr
            );

            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
    end;
}