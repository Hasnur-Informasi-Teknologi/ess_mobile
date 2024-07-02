import 'package:flutter/material.dart';
import 'package:mobile_ess/screens/admin/administrator/master%20data/master_data_cuti_bersama.dart';
import 'package:mobile_ess/screens/admin/administrator/master%20data/master_data_cuti_roster.dart';
import 'package:mobile_ess/screens/admin/administrator/master%20data/master_data_entitas.dart';
import 'package:mobile_ess/screens/admin/administrator/master%20data/master_data_kamar_hotel.dart';
import 'package:mobile_ess/screens/admin/administrator/master%20data/master_data_screen.dart';
import 'package:mobile_ess/screens/admin/administrator/master%20data/master_data_pic_hrgs.dart';
import 'package:mobile_ess/screens/admin/administrator/master%20data/master_data_rawat_inap.dart';
import 'package:mobile_ess/screens/admin/administrator/master%20data/master_data_rawat_jalan.dart';
import 'package:mobile_ess/screens/admin/administrator/master%20data/master_data_uang_makan_dalam_negeri.dart';
import 'package:mobile_ess/screens/admin/administrator/master%20data/tab%20rawat%20jalan/tabsRawatJalan.dart';
import 'package:mobile_ess/screens/admin/administrator/master%20data/tab%20uang%20makan/TabsUangMakan.dart';
import 'package:mobile_ess/screens/admin/administrator/user%20management/user_management_list.dart';
import 'package:mobile_ess/screens/admin/administrator/user_authorization/user_authorization_list.dart';
import 'package:mobile_ess/screens/admin/main/dashboard.dart';
import 'package:mobile_ess/screens/admin/main/karyawan/list_karyawan.dart';
import 'package:mobile_ess/screens/authentication/signin_screen.dart';
import 'package:mobile_ess/screens/test.dart';
import 'package:mobile_ess/screens/user/home/documents/documents_screen.dart';
import 'package:mobile_ess/screens/admin/administrator/administrator_screen.dart';
import 'package:mobile_ess/screens/user/home/online_form/aplikasi_recruitment/form_aplikasi_recruitment_screen.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_bantuan_komunikasi/form_pengajuan_bantuan_komunikasi.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_cuti/form_pengajuan_cuti.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_cuti/form_pengajuan_perpanjangan_cuti.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_cuti/pengajuan_cuti.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_fasilitas_kesehatan/form_detail_pengajuan_rawat_inap.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_fasilitas_kesehatan/form_detail_pengajuan_rawat_jalan.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_fasilitas_kesehatan/form_pengajuan_rawat_inap.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_fasilitas_kesehatan/form_pengajuan_rawat_jalan.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_fasilitas_kesehatan/pengajuan_fasilitas_kesehatan.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_hardware_software/form_permintaan_hardware_software.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_izin/form_pengajuan_lembur.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_izin/form_surat_izin_keluar.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_izin/pengajuan_izin.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_perjalanan_dinas/form_input_biaya_perjalanan_dinas.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_perjalanan_dinas/form_input_laporan_aktivitas_perjalanan_dinas.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_perjalanan_dinas/form_input_laporan_biaya_perjalanan_dinas.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_perjalanan_dinas/form_laporan_aktivitas_dan_biaya_perjalanan_dinas.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_perjalanan_dinas/form_rencana_biaya_perjalanan_dinas.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_perjalanan_dinas/pengajuan_perjalanan_dinas.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_surat_keterangan.dart/form_surat_keterangan.dart';
import 'package:mobile_ess/screens/user/home/pengumuman/detail_pengumuman_screen.dart';
import 'package:mobile_ess/screens/user/home/pengumuman/pengumuman_screen.dart';
import 'package:mobile_ess/screens/user/home/online_form/aplikasi_training/form_aplikasi_training_screen.dart';
import 'package:mobile_ess/screens/user/home/online_form/online_form_screen.dart';
import 'package:mobile_ess/screens/user/home/request_attendance/request_attendance_karwayan_screen.dart';
import 'package:mobile_ess/screens/user/home/request_attendance/ubah_data_kehadiran_screen.dart';
import 'package:mobile_ess/screens/user/home/transactions/transactions_screen.dart';
import 'package:mobile_ess/screens/user/main/main_screen_with_animation.dart';
import 'package:mobile_ess/screens/user/permintaan/detail_im_perjalanan_dinas_daftar_permintaan.dart';
import 'package:mobile_ess/screens/user/permintaan/detail_lpj_perjalanan_dinas_daftar_permintaan.dart';
import 'package:mobile_ess/screens/user/permintaan/detail_pengajuan_cuti_daftar_permintaan.dart';
import 'package:mobile_ess/screens/user/permintaan/detail_pengajuan_training_daftar_permintaan.dart';
import 'package:mobile_ess/screens/user/permintaan/detail_rawat_inap_daftar_permintaan.dart';
import 'package:mobile_ess/screens/user/permintaan/detail_rawat_jalan_daftar_permintaan.dart';
import 'package:mobile_ess/screens/user/permintaan/detail_surat_izin_keluar_daftar_permintaan.dart';
import 'package:mobile_ess/screens/user/persetujuan/detail_bantuan_komunikasi_daftar_persetujuan.dart';
import 'package:mobile_ess/screens/user/persetujuan/detail_im_perjalanan_dinas_daftar_persetujuan.dart';
import 'package:mobile_ess/screens/user/persetujuan/detail_lpj_perjalanan_dinas_daftar_persetujuan.dart';
import 'package:mobile_ess/screens/user/persetujuan/detail_pengajuan_cuti_daftar_persetujuan.dart';
import 'package:mobile_ess/screens/user/persetujuan/detail_pengajuan_training_daftar_persetujuan.dart';
import 'package:mobile_ess/screens/user/persetujuan/detail_perpanjangan_cuti_daftar_persetujuan.dart';
import 'package:mobile_ess/screens/user/persetujuan/detail_rawat_inap_daftar_persetujuan.dart';
import 'package:mobile_ess/screens/user/persetujuan/detail_rawat_jalan_daftar_persetujuan.dart';
import 'package:mobile_ess/screens/user/persetujuan/detail_surat_izin_keluar_daftar_persetujuan.dart';
import 'package:mobile_ess/screens/user/profile/profile_edit_screen.dart';
import 'package:mobile_ess/screens/user/profile/profile_screen.dart';
import 'package:mobile_ess/screens/user/permintaan/detail_bantuan_komunikasi_daftar_permintaan.dart';

import 'package:mobile_ess/splash_screen.dart';

Map<String, Widget Function(BuildContext)> routers() {
  return {
    '/': (context) => const SignInScreen(),
    '/splash': (context) => const SplashScreen(),
    '/user/main': (context) => const MainScreenWithAnimation(),
    '/user/profile': (context) => const ProfileScreen(),
    '/user/profile/edit': (context) => const ProfileEditScreen(),
    '/user/main/home/online_form': (context) => const OnlineFormScreen(),
    '/user/main/home/online_form/aplikasi_training': (context) =>
        const FormAplikasiTrainingScreen(),
    '/user/main/home/online_form/aplikasi_recruitment': (context) =>
        const FormAplikasiRecruitmentScreen(),
    '/user/main/home/online_form/pengajuan_perjalanan_dinas': (context) =>
        const PengajuanPerjalananDinas(),
    '/user/main/home/online_form/pengajuan_perjalanan_dinas/form_rencana_biaya_perjalanan_dinas':
        (context) => const FormRencanaBiayaPerjalananDinas(),
    '/user/main/home/online_form/pengajuan_perjalanan_dinas/form_rencana_biaya_perjalanan_dinas/form_input_biaya_perjalanan_dinas':
        (context) => const FormInputBiayaPerjalananDinas(),
    '/user/main/home/online_form/pengajuan_perjalanan_dinas/form_laporan_aktivitas_dan_biaya_perjalanan_dinas':
        (context) => const FormLaporanAktivitasDanBiayaPerjalananDinas(),
    '/user/main/home/online_form/pengajuan_perjalanan_dinas/form_laporan_aktivitas_dan_biaya_perjalanan_dinas/form_input_laporan_aktivitas_perjalanan_dinas':
        (context) => const FormInputLaporanAktivitasPerjalananDinas(),
    '/user/main/home/online_form/pengajuan_perjalanan_dinas/form_laporan_aktivitas_dan_biaya_perjalanan_dinas/form_input_laporan_biaya_perjalanan_dinas':
        (context) => const FormInputLaporanBiayaPerjalananDinas(),
    '/user/main/home/online_form/pengajuan_fasilitas_kesehatan': (context) =>
        const PengajuanFasilitasKesehatan(),
    '/user/main/home/online_form/pengajuan_fasilitas_kesehatan/pengajuan_rawat_jalan':
        (context) => const FormPengajuanRawatJalan(),
    '/user/main/home/online_form/pengajuan_fasilitas_kesehatan/pengajuan_rawat_jalan/detail_pengajuan_rawat_jalan':
        (context) => const FormDetailPengajuanRawatJalan(),
    '/user/main/home/online_form/pengajuan_fasilitas_kesehatan/pengajuan_rawat_inap':
        (context) => const FormPengajuanRawatInap(),
    '/user/main/home/online_form/pengajuan_fasilitas_kesehatan/pengajuan_rawat_inap/detail_pengajuan_rawat_inap':
        (context) => const FormDetailPengajuanRawatInap(),
    '/user/main/home/online_form/pengajuan_izin': (context) =>
        const PengajuanIzin(),
    '/user/main/home/online_form/pengajuan_izin/form_surat_izin_keluar':
        (context) => const FormSuratIzinKeluar(),
    '/user/main/home/online_form/pengajuan_izin/form_pengajuan_lembur':
        (context) => const FormPengajuanLembur(),
    '/user/main/home/online_form/pengajuan_bantuan_komunikasi/form_pengajuan_bantuan_komunikasi':
        (context) => const FormPengajuanBantuanKomunikasi(),
    '/user/main/home/online_form/pengajuan_hardware_software': (context) =>
        const FormPermintaanHardwareSoftware(),
    '/user/main/home/online_form/pengajuan_surat_keterangan': (context) =>
        const FormSuratKeterangan(),
    '/user/main/home/online_form/pengajuan_cuti': (context) =>
        const PengajuanCuti(),
    '/user/main/home/online_form/pengajuan_cuti/form_pengajuan_cuti':
        (context) => const FormPengajuanCuti(),
    '/user/main/home/online_form/pengajuan_cuti/form_pengajuan_perpanjangan_cuti':
        (context) => const FormPengajuanPerpanjanganCuti(),
    '/user/main/home/request_attendance': (context) =>
        const RequestAttendanceKaryawanScreen(),
    '/user/main/home/request_attendance/ubah_data_kehadiran': (context) =>
        const UbahDataKehadiranScreen(),
    '/user/main/home/pengumuman': (context) => const PengumumanScreen(),
    '/user/main/home/pengumuman/detail_pengumuman': (context) =>
        const DetailPengumumanScreen(),
    '/user/main/daftar_permintaan/detail_bantuan_komunikasi': (context) =>
        const DetailBantuanKomunikasiDaftarPermintaan(),
    '/user/main/daftar_permintaan/detail_pengajuan_cuti': (context) =>
        const DetailPengajuanCutiDaftarPermintaan(),
    '/user/main/daftar_permintaan/detail_rawat_inap': (context) =>
        const DetailRawatInapDaftarPermintaan(),
    '/user/main/daftar_permintaan/detail_rawat_jalan': (context) =>
        const DetailRawatJalanDaftarPermintaan(),
    '/user/main/daftar_permintaan/detail_im_perjalanan_dinas': (context) =>
        const DetailImPerjalananDinasDaftarPermintaan(),
    '/user/main/daftar_permintaan/detail_lpj_perjalanan_dinas': (context) =>
        const DetailLpjPerjalananDinasDaftarPermintaan(),
    '/user/main/daftar_permintaan/detail_pengajuan_training': (context) =>
        const DetailPengajuanTrainingDaftarPermintaan(),
    '/user/main/daftar_permintaan/detail_surat_izin_keluar': (context) =>
        const DetailSuratIzinKeluarDaftarPermintaan(),
    '/user/main/daftar_persetujuan/detail_rawat_inap': (context) =>
        const DetailRawatInapDaftarPersetujuan(),
    '/user/main/daftar_persetujuan/detail_rawat_jalan': (context) =>
        const DetailRawatJalanDaftarPersetujuan(),
    '/user/main/daftar_persetujuan/detail_pengajuan_cuti': (context) =>
        const DetailPengajuanCutiDaftarPersetujuan(),
    '/user/main/daftar_persetujuan/detail_perpanjangan_cuti': (context) =>
        const DetailPerpanjanganCutiDaftarPersetujuan(),
    '/user/main/daftar_persetujuan/detail_im_perjalanan_dinas': (context) =>
        const DetailImPerjalananDinasDaftarPersetujuan(),
    '/user/main/daftar_persetujuan/detail_lpj_perjalanan_dinas': (context) =>
        const DetailLpjPerjalananDinasDaftarPersetujuan(),
    '/user/main/daftar_persetujuan/detail_bantuan_komunikasi': (context) =>
        const DetailBantuanKomunikasiDaftarPersetujuan(),
    '/user/main/daftar_persetujuan/detail_pengajuan_training': (context) =>
        const DetailPengajuanTrainingDaftarPersetujuan(),
    '/user/main/daftar_persetujuan/detail_surat_izin_keluar': (context) =>
        const DetailSuratIzinKeluarDaftarPersetujuan(),

    // '/user/main/submition/aplikasi_training/detail_aplikasi_training':
    //     (context) => const DetailFormPengajuanLembur(),
    '/user/main/home/transactions': (context) => const TransactionsScreen(),
    '/user/main/home/documents': (context) => const DocumentsScreen(),
    // =================== ADMIN ====================
    '/admin/main': (context) => const AdminMainScreen(),
    '/admin/karyawan': (context) => const ListKaryawan(),
    '/test': (context) => TestScreen(),
    '/admin/administrator/administrator_screen': (contex) =>
        const Administrator(),
    '/admin/administrator/user_management/user_management': (contex) =>
        const UserManagement(),
    '/admin/administrator/user_authorization/user_authorization': (contex) =>
        const UserAuthorization(),
    '/admin/administrator/master_data/master_data_screen': (context) =>
        const MasterDataScreen(),
    '/admin/administrator/master_data/entitas': (context) => const Entitas(),
    '/admin/administrator/master_data/cuti_bersama': (context) =>
        const CutiBersama(),
    '/admin/administrator/master_data/cuti_roster': (context) =>
        const CutiRoster(),
    '/admin/administrator/master_data/tab_rawat_jalan': (context) =>
        const TabsRawatJalan(),
    '/admin/administrator/master_data/tab_uang_makan': (context) =>
        const TabsUangMakan(),
    '/admin/administrator/master_data/rawat_inap': (context) =>
        const RawatInap(),
    '/admin/administrator/master_data/kamar_hotel': (context) =>
        const KamarHotel(),
    '/admin/administrator/master_data/pic_hrgs': (context) => const PicHrgs()
  };
}
