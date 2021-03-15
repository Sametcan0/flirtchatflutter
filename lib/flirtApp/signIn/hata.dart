class Hatalar{

  static String goster(String hataKodu){
    switch(hataKodu){
      case 'The email address is already in use by another account.' :
        return "Bu mail adresi zaten kullanılıyor lütfen farklı bir mail adresi kullanın.";
      case 'There is no user record corresponding to this identifier. The user may have been deleted.' :
        return "Böyle bir mail adresi yok kayıt ol butonunu kullanarak kayıt olun";
      default :
        return "Bilinmeyen bir hata oluştu.";
    }
  }
}