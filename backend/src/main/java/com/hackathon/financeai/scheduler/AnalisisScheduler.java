package com.hackathon.financeai.scheduler;

import com.hackathon.financeai.model.Usuario;
import com.hackathon.financeai.repositories.UsuarioRepository;
import com.hackathon.financeai.service.AnalisisService;
import com.hackathon.financeai.exception.FintechException;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class AnalisisScheduler {

    private final AnalisisService analisisService;
    private final UsuarioRepository usuarioRepository;

    public AnalisisScheduler(AnalisisService analisisService, UsuarioRepository usuarioRepository) {
        this.analisisService = analisisService;
        this.usuarioRepository = usuarioRepository;
    }

    // Cron: "0 0 20 * * SUN"
    // Ejecutar todos los Domingos (SUN) a las 20:00:00 
    @Scheduled(cron = "0 0 20 * * SUN")
    public void ejecutarAnalisisSemanal() {
        System.out.println("⏳ Iniciando análisis semanal para todos los usuarios activos...");
        
        List<Usuario> usuarios = usuarioRepository.findAll();
        for (Usuario u : usuarios) {
            if (Boolean.TRUE.equals(u.getActivo())) {
                try {
                    analisisService.generarAnalisisParaUsuario(u.getId());
                } catch (FintechException e) {
                    System.err.println("⚠️ Fallo al generar análisis para " + u.getId() + " - " + e.getCodigo() + ": " + e.getMessage());
                } catch (Exception e) {
                    System.err.println("❌ Error inesperado para " + u.getId() + ": " + e.getMessage());
                }
            }
        }
        
        System.out.println("🏁 Análisis semanal masivo finalizado.");
    }
}
