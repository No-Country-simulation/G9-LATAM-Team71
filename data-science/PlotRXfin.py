def graficar_radiografia(resultado_radiografia):
    desglose = resultado_radiografia["desglose_cualidad"]
    etiquetas = list(desglose.keys())
    valores = list(desglose.values())
    
    # Definir colores semánticos (Rojo: Vital/Difícil de cortar, Amarillo: No vital, Verde: Variable/Cortable)
    colores = ['#FF6B6B', '#FFD93D', '#6BCB77']
    
    plt.figure(figsize=(8, 5))
    plt.bar(etiquetas, valores, color=colores)
    
    plt.title('Radiografía de Gastos vs Flexibilidad', fontsize=14, fontweight='bold')
    plt.ylabel('Monto ($)', fontsize=12)
    plt.grid(axis='y', linestyle='--', alpha=0.7)
    
    # Añadir los valores sobre cada barra
    for i, v in enumerate(valores):
        plt.text(i, v + (max(valores)*0.02), f"${v}", ha='center', fontweight='bold')
        
    plt.tight_layout()
    plt.show()

# Para probar la gráfica con los datos generados arriba:
# graficar_radiografia(radiografia_json)