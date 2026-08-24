package com.hackathon.financeai.repositories;

import com.hackathon.financeai.model.AnalisisFinanciero;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface AnalisisFinancieroRepository extends JpaRepository<AnalisisFinanciero, UUID> {
    Optional<AnalisisFinanciero> findFirstByUsuarioIdOrderByFechaCreacionDesc(UUID usuarioId);
}
