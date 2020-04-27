// EXAMPLE :

//SQL Insert :

procedure TFGrade_Karyawan.btSimpan1Click(Sender: TObject);
begin
with dm.qr do
      begin
        sql.Clear;
        sql.Add('insert into tbjkerja(nik,jeniskerja,spesial)');
        sql.Add('values(:nik,:jk,:sp)');
        ParamByName('nik').AsString := cbnik.Text;
        ParamByName('jk').AsString := ednamaproses.Text;
        ParamByName('sp').AsString := cbtipe.Text;
        ExecSQL;
        close;
        qrkerja.Refresh;
        cbnik.Text := '';
        ednamaproses.Text :='';
        cbtipe.Text := '';
      end;
 end;



//SQL Update :

if sts = 2 then // Update Data
begin
 with Ftransaksi_penjualan do
  with dm.qr_global do
    begin
       close;
       sql.Clear;
       sql.Add('update penjualan_obat set tgl_penjualan=:tgl,nama_konsumen=:nk,');
       sql.Add('alamat=:alm,umur=:usia,nama_dokter=:nd,specialis=:sps,nama_obat=:nob,');
       sql.Add('harga=:hrg,stok=:stk,banyak=:bny,total=:tot where no_penjualan="'+edno.Text+'"');
       ParamByName('tgl').AsDate := tanggal.date;
       ParamByName('nk').AsString := ednama.Text;
       ParamByName('alm').AsString := edalamat.Text;
       ParamByName('usia').AsInteger := strtoint(edumur.Text);
       ParamByName('nd').AsString := cbdokter.Text;
       ParamByName('sps').AsString := edspesialis.Text;
       ParamByName('nob').AsString := cbobat.Text;
       ParamByName('hrg').AsInteger := strtoint(edhs.Text);
       ParamByName('stk').AsInteger := strtoint(edstok.Text);
       ParamByName('bny').AsInteger := strtoint(edjumlah.Text);
       ParamByName('tot').AsInteger := strtoint(edtotal.Text);
       ExecSQL;
       qr_transaksi.Refresh;
       ShowMessage('Data Telah diupdate');
       close;
       clear;
       btsimpan.Caption := 'Simpan';
       lock;
     end;
 end;
end;



// SQL Delete :


procedure TFGrade_Karyawan.HapusRecord1Click(Sender: TObject);
begin
if MessageDlg('Yakin Data Akan di Hapus ?',
   mtConfirmation,[mbYes,mbNo],0)= mrYes then
with dm.qr do
  begin
    close;
    sql.Clear;
    sql.Add('delete from tbjkerja where idkerja = "'+qrkerjaidkerja.AsString+'"');
    qrkerja.Refresh;
    DBGrid2.Refresh;
    ExecSQL;
    close;
  end;
end;


// SQL Read / Search Untuk Komponen ComboBox :

procedure TFGrade_Karyawan.BTCARIClick(Sender: TObject);
begin
 with qrkaryawan do
   begin
      close;
      SQL.Clear;
      if cbunit_kerja.ItemIndex = 0 then
         sql.Add('select a.nik, a.nam_peg,a.bag,a.jab,b.tgl_masuk from idkaryawan a inner join karyawan_detail b on a.badgenumber=b.badgenumber order by nik');
      if cbunit_kerja.ItemIndex <> 0 then
        SQL.Add('select a.nik, a.nam_peg,a.bag,a.jab,b.tgl_masuk from idkaryawan a inner join  karyawan_detail b on a.badgenumber=b.badgenumber  where bag="'+cbunit_kerja.Text+'" order by nik' );
      Open;

      if Active and not IsEmpty  then
       lhasil.Caption := 'Data :'+inttostr(qrkaryawan.RecordCount)+' Record'
      else
        lhasil.Caption := 'Data : 0 Record'
      end;
end;


// SQL Read / Search Untuk Komponen edit :

procedure TFtransaksi_penjualan.cari_konsumenChange(Sender: TObject);
begin
with qr_transaksi do
  begin
   close;
   sql.Clear;
   sql.Add('Select * from penjualan_obat where nama_konsumen like '+QuotedStr(cari_konsumen.Text+'%'));
   open;
   if Active and not IsEmpty then
           Begin
             lhasil.Visible := true;
             lhasil.Caption := 'Data : '+inttostr(qr_transaksi.RecordCount)+' Record';
             tampil_gtotal;
           end
               else
                 lhasil.Caption := 'Data : 0 Record';

  end;
end;



// SQL Read / Search Untuk Komponen Date Time Picker (Tanggal) :


procedure TFtransaksi_penjualan.btcariClick(Sender: TObject);
var total : integer;
begin
with qr_transaksi do
  begin
    close;
    sql.Clear;
    sql.Add('select * from penjualan_obat where tgl_penjualan = "'+FormatDateTime('YYYY-MM-DD',tgl_cari.Date)+'" order by no_penjualan');
    open;
    if Active and not IsEmpty then
           Begin
              lhasil.Visible := true;
              lhasil.Caption := 'Data : '+inttostr(qr_transaksi.RecordCount)+' Record';
           end
               else
                 lhasil.Caption := 'Data : 0 Record';
    end;
end;



// SQL Read / Search Untuk Komponen Date Time Picker (2 Tanggal) :


procedure TFtransaksi_penjualan.btcari2Click(Sender: TObject);
var
  total : integer;
begin
with qr_transaksi do
  begin
    close;
    sql.Clear;
    sql.Add('select * from penjualan_obat where tgl_penjualan between "'+FormatDateTime('YYYY-MM-DD',TGL1.Date)+'" AND "'+FormatDateTime('YYYY-MM-DD',TGL2.Date)+'" order by no_penjualan' );
    open;
  end;
  with dm.qr_global do
     begin
        close;
        sql.Clear;
        sql.Add('select sum(total) from penjualan_obat where tgl_penjualan between "'+FormatDateTime('YYYY-MM-DD',TGL1.Date)+'" AND "'+FormatDateTime('YYYY-MM-DD',TGL2.Date)+'" order by no_penjualan' );
        open;
        total := Fields[0].AsInteger;
        edgrand_total.Text := inttostr(total);
     end;
end;



// SQL Lookup Data Tabel
procedure lookup_data;
begin
   with Fgrade_karyawan do
    begin
      with dm.qr do
    begin
      close;
      sql.Clear;
      sql.Add('select distinct (bag) from idkaryawan order by nik');
      open;
      if not IsEmpty then
        begin
          First;
            while not eof do
              Begin
                 cbunit_kerja.Items.Add(Fields[0].Asstring);
                 next;
              end;
                cbunit_kerja.ItemIndex:=0;
        end;
end;
